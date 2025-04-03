//
//  Model3DUploadViewModel.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

import Foundation
import Firebase
import FirebaseStorage
import PhotosUI
import SwiftUI

@MainActor
class Model3DUploadViewModel: ObservableObject {
    // Published properties
    @Published var selectedVideo: PhotosPickerItem?  // for storing the selected video
    @Published var videoURL: URL?
    @Published var uploadProgress: Double = 0
    @Published var uploadComplete: Bool = false
    @Published var errorMessage: String?
    @Published var model3DURL: String?  // For storing the final URL of the 3D model (e.g., USDZ file)
    
    private let storage = Storage.storage()  // Firebase Storage reference
    private let db = Firestore.firestore()  // Firestore reference
    
    // Function to handle the video selection
    func setVideo(from item: PhotosPickerItem?) {
        guard let item = item else { return }

        Task {
            do {
                let data = try await item.loadTransferable(type: Data.self)
                
                // Safely unwrap the optional `data`
                if let unwrappedData = data {
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).mov")
                    try unwrappedData.write(to: tempURL)  // Now `unwrappedData` is a non-optional Data
                    videoURL = tempURL
                    uploadVideo()  // Call the upload function after successful loading
                } else {
                    errorMessage = "Failed to load video: No data received."
                }
            } catch {
                errorMessage = "Failed to load video: \(error.localizedDescription)"
            }
        }
    }

    
    // Function to upload the video to Firebase
    func uploadVideo() {
        guard let videoURL = videoURL else {
            errorMessage = "No video to upload"
            return
        }
        
        let videoRef = storage.reference().child("3d_models/\(UUID().uuidString).mov")
        let uploadTask = videoRef.putFile(from: videoURL, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                self?.errorMessage = "Failed to upload video: \(error.localizedDescription)"
                return
            }
            
            videoRef.downloadURL { [weak self] url, error in
                if let error = error {
                    self?.errorMessage = "Failed to fetch download URL: \(error.localizedDescription)"
                    return
                }
                self?.model3DURL = url?.absoluteString
                self?.uploadComplete = true
                self?.saveModelToFirestore(url: self?.model3DURL)
            }
        }
        
        // Track progress
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            self.uploadProgress = percentComplete
        }
    }
    
    // Function to save model information to Firestore
    private func saveModelToFirestore(url: String?) {
        guard let url = url else { return }
        
        let modelData: [String: Any] = [
            "name": "3D Model",
            "fileURL": url,
            "dateCreated": Timestamp()
        ]
        
        db.collection("3DModels").addDocument(data: modelData) { error in
            if let error = error {
                self.errorMessage = "Failed to save model: \(error.localizedDescription)"
            }
        }
    }
}
