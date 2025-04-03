//
//  UploadModel3DView.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//


import SwiftUI
import PhotosUI

struct UploadModel3DView: View {
    @StateObject private var viewModel = Model3DUploadViewModel()
    
    var body: some View {
        ZStack{
            BackgroundView(imageName: "EditMenuItemBG")
            VStack {
                PhotosPicker(selection: $viewModel.selectedVideo, matching: .videos) {
                    Text("Select Video")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .onChange(of: viewModel.selectedVideo) { newItem in
                    viewModel.setVideo(from: newItem)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if viewModel.uploadComplete {
                    Text("Model uploaded successfully!")
                        .foregroundColor(.green)
                        .padding()
                    if let modelURL = viewModel.model3DURL {
                        Link("View Model", destination: URL(string: modelURL)!)
                    }
                }
                
                if !viewModel.uploadComplete && viewModel.uploadProgress > 0 {
                    ProgressView(value: viewModel.uploadProgress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                }
                
            }
            .padding()
            .navigationTitle("Upload 3D Model")
        }
        }

}

struct Model3DView_Previews: PreviewProvider {
    static var previews: some View {
        UploadModel3DView()
    }
}
