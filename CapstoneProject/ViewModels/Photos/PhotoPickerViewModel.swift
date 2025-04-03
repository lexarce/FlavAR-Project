//
//  PhotoPickerViewModel.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//
//

import SwiftUI
import PhotosUI
import FirebaseStorage

@MainActor
final class PhotoPickerViewModel: ObservableObject {

    @Published var selectedImage: UIImage? = nil
    @Published var imageURL: String? {
        didSet {
            if let imageURL = imageURL {
                onImageUpload?(imageURL) // notify parent
            }
        }
    }

    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }

    // Closure that gets triggered when image is uploaded and URL is ready
    var onImageUpload: ((String) -> Void)?

    // Folder in Firebase Storage to upload the image to (e.g., "menu_images", "profile_images")
    var uploadFolder: String

    // Init
    init(uploadFolder: String) {
        self.uploadFolder = uploadFolder
    }

    // Image Handling

    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }

        Task {
            if let data = try? await selection.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                uploadImageToFirebase(imageData: data)
            }
        }
    }

    private func uploadImageToFirebase(imageData: Data) {
        let fileName = "\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child("\(uploadFolder)/\(fileName)")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("UPLOAD ERROR: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.imageURL = url.absoluteString
                    }
                }
            }
        }
    }
}
