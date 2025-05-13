
import SwiftUI

enum ExperienceAction {
    case findProduct
    case requestExpert
    case exploreOnMyOwn
    case close
}

struct ExpertView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color.mint.opacity(0.3).ignoresSafeArea()
                VStack {
                    Text("Vista del Experto")
                        .font(.largeTitle)
                    Text("Aquí se gestionaría la asistencia.")
                        .padding()
                }
            }
            .navigationTitle("Asistencia Experta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

