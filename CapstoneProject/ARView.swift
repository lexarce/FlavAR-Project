//
//  ARView.swift
//  CapstoneProject
//
//  Created by Kaleb on 11/7/24.
//

import SwiftUI
import RealityKit
import ARKit

// MARK: - ARView Container
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
        uiView.scene.anchors.removeAll()
        guard let modelEntity = try? Entity.loadModel(named: modelName) else { return }
        modelEntity.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])
        modelEntity.transform.scale = [scaleFactor, scaleFactor, scaleFactor]
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(modelEntity)
        uiView.scene.addAnchor(anchorEntity)
    }
}

// MARK: - AR Sheet View
struct SheetView: View {
    @Binding var isPresented: Bool
    @State var modelName: String = "shoe"
    @State private var rotationAngle: Float = 0.0
    @State private var scaleFactor: Float = 0.01

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ARViewContainer(modelName: $modelName, rotationAngle: $rotationAngle, scaleFactor: $scaleFactor)
                .ignoresSafeArea(edges: .all)

            VStack {
                ARModelTitle(title: "Cool Shoe Model")
                Spacer()
                ARControls(
                    scaleFactor: $scaleFactor,
                    rotationAngle: $rotationAngle
                )
            }
            .frame(maxWidth: .infinity)

            ARCloseButton { isPresented.toggle() }
        }
    }
}

// MARK: - Subviews
struct ARModelTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal)
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .padding(.top, 24)
    }
}

struct ARCloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark.circle")
                .font(.largeTitle)
                .foregroundColor(.black)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding(24)
    }
}

struct ARControls: View {
    @Binding var scaleFactor: Float
    @Binding var rotationAngle: Float

    var body: some View {
        VStack {
            Spacer()
            ZoomControls(scaleFactor: $scaleFactor)
            RotationControls(rotationAngle: $rotationAngle)
        }
    }
}

struct ZoomControls: View {
    @Binding var scaleFactor: Float

    var body: some View {
        HStack(spacing: 20) {
            ARControlButton(label: "Zoom Out") {
                scaleFactor = max(0.005, scaleFactor - 0.001)
            }
            ARControlButton(label: "Zoom In") {
                scaleFactor = min(0.02, scaleFactor + 0.001)
            }
        }
        .padding(.bottom, 20)
    }
}

struct RotationControls: View {
    @Binding var rotationAngle: Float

    var body: some View {
        HStack(spacing: 20) {
            ARControlButton(label: "Rotate Left") {
                rotationAngle -= .pi / 4
            }
            ARControlButton(label: "Rotate Right") {
                rotationAngle += .pi / 4
            }
        }
        .padding(.bottom, 50)
    }
}

struct ARControlButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title2)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var isPresented: Bool = false

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
        .fullScreenCover(isPresented: $isPresented) {
            SheetView(isPresented: $isPresented)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
