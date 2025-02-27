//
//  MenuItemImageView.swift
//  CapstoneProject
//
//  Created by Alexis Arce on 2/26/25.
//

import SwiftUI

// Loads images from Firebase Storage

struct MenuItemImageView: View {
    let imagePath: String
    @State private var downloadedImage: UIImage? = nil

    var body: some View {
        if let image = downloadedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .overlay(ProgressView())
                .onAppear {
                    let imageDownloader = ImageDownloader()
                    imageDownloader.downloadImage(from: imagePath) { uiImage in
                        DispatchQueue.main.async { self.downloadedImage = uiImage }
                    }
                }
        }
    }
}
