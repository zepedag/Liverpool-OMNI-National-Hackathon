import SwiftUI
import ARKit
import SceneKit

struct ARDirectionView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true

        // Configuración de la sesión AR
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)

        // Agrega la flecha
        let arrowNode = createArrowNode()
        let destination = SCNVector3(0, 0, -5) // 5 metros al frente
        arrowNode.position = SCNVector3(0, 0, -1) // Mostrarla a 1 metro del usuario
        arrowNode.look(at: destination)
        sceneView.scene.rootNode.addChildNode(arrowNode)

        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Aquí puedes actualizar la vista si cambian datos externos
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, ARSCNViewDelegate {}

    // Flecha simple como cono
    func createArrowNode() -> SCNNode {
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.2)
        cone.firstMaterial?.diffuse.contents = UIColor.systemRed

        let coneNode = SCNNode(geometry: cone)
        coneNode.eulerAngles.x = -.pi / 2 // Apuntar hacia adelante
        return coneNode
    }
}

struct ARDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Vista AR no disponible en previsualización")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
    }
}


