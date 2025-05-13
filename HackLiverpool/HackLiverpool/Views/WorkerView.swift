import SwiftUI

struct WorkerView: View {
    @State private var isAttending: Bool = false // Estado para controlar si se está atendiendo
    @State private var isFinished: Bool = false
    @State private var circleScale: CGFloat = 1.0 // Estado para controlar la escala del círculo
    @State private var animateCircle: Bool = false // Estado para activar la animación
    @State var clientname: String // Variable para el nombre del cliente
    @State var profileImage: String // Nombre del asset de la imagen
    @State private var isBusy: Bool = false

    var body: some View {
        ZStack(alignment: .topLeading) { // Alineamos los elementos a la esquina superior izquierda para la minimizada
            // Fondo inicial rosa
            Color.liverpoolPink
                .edgesIgnoringSafeArea(.all)
            if isBusy{
                LiverpoolView(isBusy: $isBusy)
            }else{
            VStack(spacing: 0) { // Reducimos el spacing
                VStack(spacing: 100) { // Contenedor para nombre e imagen con fondo rosa reducido
                    // Nombre del cliente
                    Text(clientname)
                        .font(isFinished ? .largeTitle : (isAttending ? .title : .largeTitle)) // Cambia el tamaño de la fuente
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .bold()
                        .lineLimit(1) // Asegura que el nombre no se extienda horizontalmente
                    // Imagen de perfil
                    Image(profileImage)
                        .resizable()
                        .scaledToFit()
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .frame(width: isAttending ? 150 : 250, height: isAttending&&isFinished ? 300 : 100) // Cambia el tamaño del frame
                        .padding()
                    if !isFinished && !isAttending || isAttending && !isFinished {
                        ItemView(isAttending: $isAttending, isFinished: $isFinished)

                    } else if isFinished {
                        Text("¡Listo!") // Puedes reemplazar esto con tu animación de Lottie si lo prefieres
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .transition(.opacity)
                            .bold()
                        Button("Siguiente cliente") {
                            print("Siguiente Cliente")
                            withAnimation { // Añadimos una animación para la transición
                                isFinished = false // Cambiamos el estado al presionar "Apoyo finalizado"
                                isAttending = false
                                clientname = "Esteban"
                                profileImage = "TestClient"
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.liverpoolPink)
                        .cornerRadius(10)
                        .font(.title)                    }
                }
                .frame(maxWidth: .infinity, alignment: .top) // Ocupar todo el ancho disponible para el fondo rosa reducido
                .background(Color.liverpoolPink) // Fondo rosa alrededor del nombre e imagen
                .padding(.top, isAttending ? UIScreen.main.bounds.height / 23 : UIScreen.main.bounds.height / 23) // Ajustar la posición inicial
                .padding(.bottom, isAttending ? UIScreen.main.bounds.height / 28 : UIScreen.main.bounds.height / 28) // Ajustar la posición inicial

                Spacer() // Empuja el botón hacia abajo si la lista no está visible

                if isAttending && !isFinished {
                    Button("Apoyo finalizado") {
                        print("Apoyo finalizado")
                        withAnimation { // Añadimos una animación para la transición
                            isFinished = true // Cambiamos el estado al presionar "Apoyo finalizado"
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.liverpoolPink)
                    .cornerRadius(10)
                    .font(.title)
                } else if !isAttending {
                    HStack(spacing: 80) {
                        Button("Atender") {
                            print("Atender")
                            withAnimation { // Añadimos una animación para la transición
                                isAttending = true // Cambiamos el estado al presionar "Atender"
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.liverpoolPink)
                        .cornerRadius(10)
                        .font(.title)

                        Button("Ocupado") { // Corrección del texto del segundo botón
                            // Acción cuando el cliente está ocupado (aquí debería ser la acción del trabajador)
                            print("Ocupado")
                            withAnimation {
                                isBusy = true
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.liverpoolPink)
                        .cornerRadius(10)
                        .font(.title)
                    }
                    .padding(.bottom)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top) // Alineamos al top para la minimizada
        }
    }
}
    struct ItemView: View {
        @Binding var isAttending: Bool
        @Binding var isFinished: Bool
        @State private var imageList: [ImageData] = [
            ImageData(imageName: "LATTAFA", description: "Eau de parfum Yara para mujer", brand: "LATTAFA", barcode: "237454938223", comments: "100 mL"),
            ImageData(imageName: "DIOR", description: "Eau de toilette Sauvage para hombre", brand: "DIOR", barcode: "234234123423", comments: "100 mL"),
            ImageData(imageName: "HERMES", description: "Eau de parfum Terre d'Hermès para hombre", brand: "HERMÈS", barcode: "732641823643", comments: "75 mL"),
            ImageData(imageName: "CHANEL", description: "CHANCE EAU SPLENDIDE", brand: "CHANEL", barcode: "731763249123", comments: "100 mL")
        ]
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(imageList) { imageData in
                        HStack {
                            VStack(alignment: .leading) {
                                Image(imageData.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(10)
                                
                                Text("Descripción: \(imageData.description)")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .lineLimit(3)
                                Text("Marca: \(imageData.brand)")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Text("Código de barras: \(imageData.barcode)")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                Text("Comentarios: \(imageData.comments)")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .lineLimit(3)
                            }
                            .frame(width: 300)
                            if isAttending{
                                Button {
                                    if let index = imageList.firstIndex(where: { $0.id == imageData.id }) {
                                        imageList.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .font(.title)
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: isAttending ? 350:300)
            .scaledToFit()
            .background(.white)
        }
    }
}
struct LiverpoolView: View {
    @Binding var isBusy: Bool
    var body: some View {
        ZStack {
            Color.liverpoolPink
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Liverpool")
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("Es parte de tu vida")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Button("Desocupado") { // Corrección del texto del segundo botón
                    // Acción cuando el cliente está ocupado (aquí debería ser la acción del trabajador)
                    print("Desocupado")
                    withAnimation {
                        isBusy = false
                    }
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.liverpoolPink)
                .cornerRadius(10)
                .font(.title)
                
            }
        }
    }
}
struct ImageData: Identifiable {
    let id = UUID()
    let imageName: String
    let description: String
    let brand: String
    let barcode: String
    let comments: String
}

// Para previsualizar esta vista en Xcode:
struct WorkerViewPreview: PreviewProvider {
    static var previews: some View {
        WorkerView(clientname: "Maria Alicia", profileImage: "Tita")
    }
}
