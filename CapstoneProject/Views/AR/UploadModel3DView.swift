//
//  UploadModel3DView.swift
//  CapstoneProject
//
//  Created by kimi on 4/3/25.
//

/*
import SwiftUI
import PhotosUI
import USDZScanner

struct UploadModel3DView: View {
    @StateObject private var viewModel = Model3DUploadViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView(imageName: "EditMenuItemBG")
            
            VStack(spacing: 16) {
                
                // MARK: - USDZ Scanner Button
                Button(action: {
                    viewModel.isUSDZScannerPresented = true
                }) {
                    Text("Scan with Camera")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // MARK: - Video Picker Option
                PhotosPicker(selection: $viewModel.selectedVideo, matching: .videos) {
                    Text("Select Video")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .onChange(of: viewModel.selectedVideo) { newItem in
                    viewModel.setVideo(from: newItem)
                }

                // MARK: - Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // MARK: - Upload Complete
                if viewModel.uploadComplete {
                    Text("Model uploaded successfully!")
                        .foregroundColor(.green)

                    if let modelURL = viewModel.model3DURL,
                       let url = URL(string: modelURL) {
                        Link("View Model", destination: url)
                            .padding(.top, 4)
                    }
                }

                // MARK: - Upload Progress
                if !viewModel.uploadComplete && viewModel.uploadProgress > 0 {
                    ProgressView(value: viewModel.uploadProgress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Upload 3D Model")
        }

        // MARK: - USDZ Scanner Sheet
        .sheet(isPresented: $viewModel.isUSDZScannerPresented) {
            USDZScanner { url in
                viewModel.handleScannedUSDZ(url: url)
                viewModel.isUSDZScannerPresented = false
            }
        }
    }
}

struct Model3DView_Previews: PreviewProvider {
    static var previews: some View {
        UploadModel3DView()
    }
}
 
*/
