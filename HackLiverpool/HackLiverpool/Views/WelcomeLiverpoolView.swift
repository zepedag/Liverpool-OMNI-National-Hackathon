import SwiftUI


extension Color {
    static let liverpoolPink = Color(red: 225/255, green: 0/255, blue: 152/255)
}

struct NextScreenView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack {
                Text("¡Esta es la siguiente pantalla!")
                    .font(.title)
                    .padding()

                Button("Volver") {
                    dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
    }
}


struct WelcomeLiverpoolView: View {
    @State private var showNextScreen = false
    let swipeThreshold: CGFloat = -100 // Sensibilidad del swipe

    // 1. Estado para la animación de la flecha
    @State private var arrowOffsetY: CGFloat = 0

    var body: some View {
        ZStack {
            // Fondo
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
                    // Inicia la animación cuando la vista aparece
                    withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        arrowOffsetY = -12 // Mueve las flechas hacia arriba
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < swipeThreshold && abs(value.translation.width) < abs(value.translation.height) {
                        self.showNextScreen = true
                    }
                }
        )
        .fullScreenCover(isPresented: $showNextScreen) {
            NextScreenView()
        }
    }
}

struct WelcomeLiverpoolView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeLiverpoolView()
    }
}
