import SwiftUI
import ARKit
import SceneKit
import CoreLocation

struct ARDirectionView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    let destinationLocation: CLLocation

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)

        return sceneView
    }

    func updateUIView(_ sceneView: ARSCNView, context: Context) {
        guard let current = locationManager.currentLocation else { return }

        sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }

        let direction = directionVector(from: current, to: destinationLocation)

        let arrowNode = createArrowNode()
        arrowNode.position = SCNVector3(0, 0, -1)
        arrowNode.look(at: direction)

        sceneView.scene.rootNode.addChildNode(arrowNode)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, ARSCNViewDelegate {}

    func createArrowNode() -> SCNNode {
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.2)
        cone.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: cone)
        node.eulerAngles.x = -.pi / 2
        return node
    }
}
struct ARDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("AR Preview no disponible")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}

