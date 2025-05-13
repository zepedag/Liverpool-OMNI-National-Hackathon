
import SwiftUI

struct OptionButtonView: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) { // Espaciado entre ícono y texto
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .medium)) // Ícono más grande
                    .foregroundColor(Color.liverpoolPink) // Necesita Color.liverpoolPink
                    .frame(width: 30, alignment: .center) // Ancho para el ícono

                Text(title)
                    .font(.system(size: 16, weight: .medium)) // Texto del botón más grande
                    .foregroundColor(.primary)
                    .lineLimit(1) // Preferiblemente una línea con texto corto

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium)) // Chevron un poco más grande
                    .foregroundColor(.secondary)
            }
            // Padding interno del botón para hacerlo más grande
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12) // Bordes redondeados
        }
    }
}

struct SelectExperienceOverlayView: View {
    // 'onAction' espera el 'ExperienceAction' global.
    var onAction: (ExperienceAction) -> Void

    var body: some View {
        VStack(spacing: 18) { // Espaciado entre elementos del VStack
            Text("Elige una opción") // Título más corto e intuitivo
                .font(.system(size: 20, weight: .semibold)) // Fuente del título más grande
                .padding(.top, 20) // Más espacio arriba
                .padding(.bottom, 10) // Espacio debajo del título

            OptionButtonView(
                iconName: "safari.fill", // Ícono más directo para búsqueda
                title: "Ir al producto",    // Texto corto
                action: {
                    onAction(.findProduct)
                }
            )

            OptionButtonView(
                iconName: "figure.stand.line.dotted.figure.stand", // Ícono para asistencia
                title: "Pedir ayuda",        // Texto corto
                action: {
                    onAction(.requestExpert)
                }
            )

            OptionButtonView(
                iconName: "figure.walk", // Ícono para explorar
                title: "Explorar solo",      // Texto corto
                action: {
                    onAction(.exploreOnMyOwn)
                }
            )

            Button {
                onAction(.close)
            } label: {
                Text("Cerrar")
                    .font(.system(size: 16, weight: .semibold)) // Fuente del botón "Cerrar"
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)) // Padding del botón
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
            }
            .padding(.top, 10) // Espacio antes del botón cerrar
            .padding([.horizontal, .bottom], 20) // Padding horizontal y al fondo
        }
        .padding(.horizontal, 15) // Padding horizontal del VStack contenedor
        .frame(width: 310, height: 400) // Ajuste del tamaño del overlay
        .background(Material.regular)
        .cornerRadius(25) // Bordes más redondeados para el overlay
        .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

// Preview para SelectExperienceOverlayView
struct SelectExperienceOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        // Asegúrate de que ExperienceAction y Color.liverpoolPink estén definidas
        // globalmente para que esta preview funcione correctamente.
        ZStack {
            Color.blue.ignoresSafeArea() // Un fondo para la preview
            SelectExperienceOverlayView(onAction: { action in
                print("Preview action: \(action)")
            })
        }
    }
}

