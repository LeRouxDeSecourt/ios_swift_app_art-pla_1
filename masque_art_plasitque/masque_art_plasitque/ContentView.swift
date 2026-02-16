import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    var body: some View {
        Group {
            if ARFaceTrackingConfiguration.isSupported {
                ARViewContainer()
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 12) {
                    Text("Face tracking not supported")
                        .font(.headline)
                    Text("This device does not support front camera face tracking.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Configure face tracking with the front TrueDepth camera
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        // Create a face anchor and place the model relative to the user's face
        let faceAnchor = AnchorEntity(.face)

        let model = try! Entity.load(named: "nn")
        // Place slightly forward along the Z axis so it sits on the face
        model.position = [0, 0, 0.05]

        faceAnchor.addChild(model)
        arView.scene.addAnchor(faceAnchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // No dynamic updates needed for this simple setup.
    }
}

#Preview {
    ContentView()
}
