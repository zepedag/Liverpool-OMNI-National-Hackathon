import SwiftUI

struct SelectExperienceView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var navigateToHomeViewRoot: Bool
    
    @State private var navigateToProduct = false
    @State private var navigateToArrowView = false
    @State private var navigateToExpert = false
    @State private var navigateToNavigationBar = false // Nuevo estado para NavigationBar
    @State private var showExitMessage = false
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("¿Qué deseas hacer?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                                
                // Navigate to different views based on state
                NavigationLink(destination: VerDespuesEnTiendaView(), isActive: $navigateToProduct) {
                    EmptyView()
                }
                
                NavigationLink(destination: ArrowView(navigateToHomeViewRoot: $navigateToHomeViewRoot), isActive: $navigateToArrowView) {
                    EmptyView()
                }
                
                NavigationLink(destination: WorkerView(clientname: "Maria Alicia", profileImage: "Tita"), isActive: $navigateToExpert) {
                    EmptyView()
                }
                
                // Nuevo NavigationLink para ir a NavigationBar
                NavigationLink(destination: NavigationBar(), isActive: $navigateToNavigationBar) {
                    EmptyView()
                }
                
                // Use the overlay for selection
                SelectExperienceOverlayView(onAction: handleAction)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleAction(_ action: ExperienceAction) {
        switch action {
        case .findProduct:
            navigateToProduct = true
        case .requestExpert:
            navigateToExpert = true
        case .exploreOnMyOwn:
            showExitMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                navigateToHomeViewRoot = true
                dismiss()
            }
        case .close:
            // Redirección a NavigationBar cuando se presiona el botón Cerrar
            navigateToNavigationBar = true
        }
    }
}

// MARK: - Option Button View
struct OptionButtonView: View {
    let iconName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color.liverpoolPink)
                    .frame(width: 30, alignment: .center)

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}


// MARK: - Select Experience Overlay View
struct SelectExperienceOverlayView: View {
    var onAction: (ExperienceAction) -> Void

    @State private var showMessage = false

    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                if showMessage {
                    VStack {
                        Spacer()
                        Text("¡Disfrute su visita!")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.liverpoolPink)
                            .multilineTextAlignment(.center)
                            .padding()
                            .transition(.opacity)
                        Spacer()
                    }
                } else {
                    Text("Elige una opción")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.white)
                        .padding(.top, 20)
                        .padding(.bottom, 10)

                    OptionButtonView(
                        iconName: "safari.fill",
                        title: "Ir al producto",
                        action: {
                            onAction(.findProduct)
                        }
                    )

                    OptionButtonView(
                        iconName: "figure.stand.line.dotted.figure.stand",
                        title: "Pedir ayuda",
                        action: {
                            onAction(.requestExpert)
                        }
                    )

                    OptionButtonView(
                        iconName: "figure.walk",
                        title: "Explorar solo",
                        action: {
                            withAnimation {
                                showMessage = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    onAction(.exploreOnMyOwn)
                                }
                            }
                        }
                    )

                    Button {
                        onAction(.close)
                    } label: {
                        Text("Cerrar")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                            .frame(maxWidth: .infinity)
                            .background(Color.liverpoolPink.opacity(0.3))
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 10)
                    .padding([.horizontal, .bottom], 20)
                }
            }
            .padding(.horizontal, 15)
            .frame(width: 310, height: 400)
            .background(Color.liverpoolPink)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)
        }
    }
}

// Preview para SelectExperienceOverlayView
struct SelectExperienceOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white.ignoresSafeArea() // Un fondo para la preview
            SelectExperienceOverlayView(onAction: { action in
                print("Preview action: \(action)")
            })
        }
    }
}
