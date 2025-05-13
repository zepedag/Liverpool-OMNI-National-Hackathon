//Usar dismiss para el botón de cerrar
import SwiftUI

extension Color {
    static let liverpoolPink = Color(red: 225/255, green: 0/255, blue: 152/255)
}

struct WelcomeLiverpoolView: View {
    @State private var showArrowView = false
    @State private var navigateToHomeViewRoot = false
    
    let swipeThreshold: CGFloat = -100
    @State private var arrowOffsetY: CGFloat = 0

    var body: some View {
    
        ZStack {
            if navigateToHomeViewRoot {
                HomeView()
            } else {
                ZStack {
                    Color.liverpoolPink
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        Text("¡Bienvenido a Liverpool!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                        VStack(spacing: -5) {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                                .offset(y: arrowOffsetY)
                            Image(systemName: "chevron.up")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .offset(y: arrowOffsetY)
                        }
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                arrowOffsetY = -12
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height < swipeThreshold && abs(value.translation.width) < abs(value.translation.height) {
                                self.navigateToHomeViewRoot = false // Asegurarse de que no esté activo
                                self.showArrowView = true
                            }
                        }
                )
                .fullScreenCover(isPresented: $showArrowView) {
                    ArrowView(navigateToHomeViewRoot: $navigateToHomeViewRoot)
                }
                // Transición para cuando cambia entre Welcome y Home
                .transition(.asymmetric(insertion: .opacity, removal: .opacity))
            }
        }
        .animation(.default, value: navigateToHomeViewRoot) // Animar el cambio a HomeView
    }
}

struct WelcomeLiverpoolView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeLiverpoolView()
    }
}
