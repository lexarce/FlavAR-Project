//
//  ARView.swift
//  CapstoneProject
//
//  Created by Kaleb on 11/7/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelName: String
    @Binding var rotationAngle: Float
    @Binding var scaleFactor: Float

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic

        arView.session.run(config)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Remove existing anchors to avoid adding multiple instances of the model
        uiView.scene.anchors.removeAll()

        // Create an anchor
        let anchorEntity = AnchorEntity(plane: .any)

        // Load the model entity
        guard let modelEntity = try? Entity.loadModel(named: modelName) else { return }

        // Apply rotation
        modelEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
        modelEntity.transform.scale = [scaleFactor, scaleFactor, scaleFactor]
        
        // Attach model to anchor and add to the ARView
        anchorEntity.addChild(modelEntity)
        uiView.scene.addAnchor(anchorEntity)
    }
}

//This controls the camera view
struct SheetView: View {
    @Binding var isPresented: Bool
    @State var modelName: String = "shoe" //This is a test model for a cool shoe
    @State private var rotationAngle: Float = 0.0
    @State private var scaleFactor: Float = 0.01

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ARViewContainer(modelName: $modelName, rotationAngle: $rotationAngle, scaleFactor: $scaleFactor)
                .ignoresSafeArea(edges: .all)

            // Title and Nutritional Description
            VStack {
                // Centered Title
                Text("cool shoe model")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 24)

                Spacer()
            }
            .frame(maxWidth: .infinity) // Center horizontally

            // Nutritional Description on the left
            VStack(alignment: .leading) {
                Text("Calories: 150\nProtein: 10g\nCarbs: 20g\nFat: 5g")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.top, 80)
                    .padding(.leading, 24)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Close button
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(24)

            // Rotate button
            VStack {
                Spacer()
                
                HStack(spacing: 20) {
                    // Zoom out button
                    Button("Zoom Out") {
                        scaleFactor = max(0.005, scaleFactor - 0.001) // Prevent scaling below 0.5
                    }
                    .font(.title2)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    // Zoom in button
                    Button("Zoom In") {
                        scaleFactor = min(0.02, scaleFactor + 0.001) // Prevent scaling above 3.0
                    }
                    .font(.title2)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
                HStack(spacing: 110) {
                    Button("Rotate Left") {
                        rotationAngle -= .pi / 4
                    }
                    .font(.title2)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    
                    Button("Rotate Right") {
                        rotationAngle += .pi / 4
                    }
                    .font(.title2)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
                .padding(.bottom, 50)
            }
        }
    }
}

//A test view for the AR Model
struct ContentView: View {
    @State var isPresented: Bool = false

    var body: some View {
        VStack {
            
            Button {
                isPresented.toggle()
            } label: {
                Label("View Example Model in AR", systemImage: "arkit")
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(24)
        }
        .padding()
        .fullScreenCover(isPresented: $isPresented, content: {
            SheetView(isPresented: $isPresented)
        })
    }
}
