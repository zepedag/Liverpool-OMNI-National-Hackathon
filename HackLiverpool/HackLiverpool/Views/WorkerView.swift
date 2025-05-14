import SwiftUI

// Extensión para colores de Liverpool

// Constantes de UI
struct LiverpoolUI {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 5
    static let standardPadding: CGFloat = 16
    static let largeSpacing: CGFloat = 24
}

struct WorkerView: View {
    @State private var isAttending: Bool = false
    @State private var isFinished: Bool = false
    @State var clientname: String
    @State var profileImage: String
    @State private var isBusy: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Fondo con gradiente de Liverpool
            Color.white
                   .edgesIgnoringSafeArea(.all)
            
            // Patrones decorativos de Liverpool (sutiles)
           
            
            if isBusy {
                LiverpoolBusyView(isBusy: $isBusy)
            } else {
                VStack() {
                    // Barra superior con logo
                    HStack {
                        Image("logoLiverpool")
                            .resizable()
                            .frame(width: 50, height: 50) // Ajusta el tamaño aquí
                            .foregroundColor(.black)
                            .font(.system(size: 28, weight: .bold))
                        Text("Liverpool")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.liverpoolDarkPink)
                    
                    ScrollView {
                        VStack(spacing: LiverpoolUI.largeSpacing) {
                            // Sección de Cliente
                            clientSection
                            
                            // Productos
                            if !isFinished && isAttending {
                                Text("Artículos seleccionados")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                                ItemView(isAttending: $isAttending, isFinished: $isFinished)
                                    .frame(height: UIScreen.main.bounds.height * 0.4)
                            } else if isFinished {
                                finishedView
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                    
                    // Botones de acción en la parte inferior
                    actionButtonsView
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // Vista del perfil del cliente
    private var clientSection: some View {
        VStack(spacing: 16) {
            if !isAttending {
                Text("Cliente en espera")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black.opacity(0.9))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(LiverpoolUI.cornerRadius)
            }
            
            HStack(spacing: 20) {
                // Foto de perfil
                Image(profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: isAttending ? 100 : 140, height: isAttending ? 100 : 140)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 3))
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 5)
                    .animation(.spring(), value: isAttending)
                
                // Información del cliente
                VStack(alignment: .leading, spacing: 8) {
                    Text(clientname)
                        .font(.system(size: isAttending ? 24 : 24, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    if isAttending {
                        Text("Cliente Premium")
                            .font(.system(size: 16))
                            .foregroundColor(.black.opacity(0.8))
                        
                        Label("Membresía Platinum", systemImage: "star.fill")
                            .font(.system(size: 15))
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                    .fill(Color.black.opacity(0.1))
            )
            .padding(.horizontal)
        }
    }
    
    // Vista cuando se termina de atender al cliente
    private var finishedView: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.black)
            
            Text("¡Atención completada!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            
            Text("Has atendido con éxito a \(clientname)")
                .font(.system(size: 18))
                .foregroundColor(.black.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal)
    }
    
    // Botones de acción
    private var actionButtonsView: some View {
        VStack {
            if isAttending && !isFinished {
                Button {
                    withAnimation {
                        isFinished = true
                    }
                } label: {
                    Text("Finalizar atención")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.liverpoolPink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        )
                }
            } else if !isAttending && !isFinished {
                HStack(spacing: 20) {
                    Button {
                        withAnimation {
                            isAttending = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("Atender ahora")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.liverpoolPink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        )
                    }
                    
                    Button {
                        withAnimation {
                            isBusy = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Ocupado")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.liverpoolGray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                        )
                    }
                }
            } else if isFinished {
                Button {
                    withAnimation {
                        isFinished = false
                        isAttending = false
                        clientname = "Esteban"
                        profileImage = "TestClient"
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.right")
                        Text("Siguiente cliente")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.liverpoolPink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                    )
                }
            }
        }
        .padding()
        .background(Color.liverpoolPink)
    }
}

struct ItemView: View {
    @Binding var isAttending: Bool
    @Binding var isFinished: Bool
    @State private var imageList: [ImageData] = [
        ImageData(imageName: "LATTAFA", description: "Eau de parfum Yara para mujer", brand: "LATTAFA", barcode: "237454938223", comments: "100 mL", price: "$1,299.00"),
        ImageData(imageName: "DIOR", description: "Eau de toilette Sauvage para hombre", brand: "DIOR", barcode: "234234123423", comments: "100 mL", price: "$2,599.00"),
        ImageData(imageName: "HERMES", description: "Eau de parfum Terre d'Hermès para hombre", brand: "HERMÈS", barcode: "732641823643", comments: "75 mL", price: "$2,199.00"),
        ImageData(imageName: "CHANEL", description: "CHANCE EAU SPLENDIDE", brand: "CHANEL", barcode: "731763249123", comments: "100 mL", price: "$2,799.00")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(imageList) { product in
                    ProductCard(product: product, onDelete: {
                        if let index = imageList.firstIndex(where: { $0.id == product.id }) {
                            withAnimation {
                                imageList.remove(at: index)
                            }
                        }
                    }, isAttending: isAttending)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ProductCard: View {
    let product: ImageData
    let onDelete: () -> Void
    let isAttending: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Imagen del producto con distintivo de marca
            ZStack(alignment: .topTrailing) {
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.liverpoolLightGray, lineWidth: 1)
                    )
                
                // Distintivo de marca
                Text(product.brand)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.liverpoolPink)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .offset(x: -5, y: 5)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.description)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(product.price)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.liverpoolPink)
                
                HStack {
                    Image(systemName: "barcode")
                        .font(.system(size: 12))
                        .foregroundColor(.liverpoolGray)
                    
                    Text(product.barcode)
                        .font(.system(size: 12))
                        .foregroundColor(.liverpoolGray)
                }
                
                Text(product.comments)
                    .font(.system(size: 12))
                    .foregroundColor(.liverpoolGray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            
            if isAttending {
                Button(action: onDelete) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Eliminar")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.liverpoolPink)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 8)
                .padding(.top, 4)
            }
        }
        .frame(width: 200)
        .background(Color.white)
        .cornerRadius(LiverpoolUI.cornerRadius)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
    }
}

struct LiverpoolBusyView: View {
    @Binding var isBusy: Bool
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                // Logo animado
                Image("logoLiverpool")
                    .resizable()
                    .frame(width: 100, height: 100) // Ajusta el tamaño aquí
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: 0)
                   // .rotationEffect(.degrees(isBusy ? 360 : 0))
                    .animation(Animation.linear(duration: 8).repeatForever(autoreverses: false), value: isBusy)
                    .onAppear {
                        isBusy = true
                    }
                
                VStack(spacing: 16) {
                    Text("Liverpool")
                        .font(.system(size: 46, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Es parte de tu vida")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black.opacity(0.9))
                }
                
                VStack(spacing: 10) {
                    Text("Modo ocupado")
                        .font(.system(size: 18))
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text("No estás recibiendo clientes en este momento")
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    withAnimation {
                        isBusy = false
                    }
                } label: {
                    HStack {
                        Image(systemName: "person.fill.checkmark")
                        Text("Volver a atender")
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.liverpoolPink)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 30)
                    .background(
                        RoundedRectangle(cornerRadius: LiverpoolUI.cornerRadius)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    )
                }
                .padding(.top, 24)
            }
            .padding()
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
    let price: String
}

// Para previsualizar esta vista en Xcode:
struct WorkerViewPreview: PreviewProvider {
    static var previews: some View {
        WorkerView(clientname: "Maria Alicia", profileImage: "Tita")
    }
}
