//
//  ImageDownloader.swift
//  CapstoneProject
//
//  Created by Kaleb on 10/11/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import UIKit

class ImageDownloader {
    
    // Function to download an image from Firebase Storage given the image path
    func downloadImage(from path: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child(path)
        
        // Download the image data with a max size
        imageRef.getData(maxSize: 8 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)  // Return nil if there's an error
                return
            }
            
            if let imageData = data, let uiImage = UIImage(data: imageData) {
                completion(uiImage)  // Return the image if successful
            } else {
                completion(nil)  // Return nil if unsuccessful
            }
        }
    }
}

