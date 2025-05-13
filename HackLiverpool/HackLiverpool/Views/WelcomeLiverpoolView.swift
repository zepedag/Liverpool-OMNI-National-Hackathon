import SwiftUI


extension Color {
    static let liverpoolPink = Color(red: 225/255, green: 0/255, blue: 152/255)
}

struct WelcomeLiverpoolView: View {
    var body: some View {
        ZStack {
            Color.liverpoolPink
                .edgesIgnoringSafeArea(.all)
            
            Text("¡Bienvenido a Liverpool!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

// Para previsualizar esta vista en Xcode:
struct WelcomeLiverpoolView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeLiverpoolView()
    }
}
