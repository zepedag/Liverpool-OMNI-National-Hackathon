
import SwiftUI

extension Color {
    static let liverpoolPink = Color(red: 225/255, green: 0/255, blue: 152/255)
}

struct WelcomeLiverpoolView: View {
    @State private var showNextScreen = false
    let swipeThreshold: CGFloat = -100
    @State private var arrowOffsetY: CGFloat = 0

    var body: some View {
        ZStack {
            Color.liverpoolPink // Ahora utiliza la extensión definida arriba
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
                        self.showNextScreen = true
                    }
                }
        )
        .sheet(isPresented: $showNextScreen) {
            SelectExperienceView()
        }
    }
}

struct WelcomeLiverpoolView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeLiverpoolView()
    }
}
