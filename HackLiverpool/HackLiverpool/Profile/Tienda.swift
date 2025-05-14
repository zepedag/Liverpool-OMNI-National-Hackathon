import SwiftUI

struct SavedProduct: Identifiable {
    let id = UUID()
    let name: String
    let capacity: String
    let price: Double
    let version: String
    let sellerName: String
    let productImageName: String
    let dateAdded: String
}

struct VerDespuesEnTiendaView: View {
    // Lista de productos guardados
    @State private var savedProducts: [SavedProduct] = [
        SavedProduct(
            name: "Eau de parfum Kenzo Flower para mujer",
            capacity: "100 ml",
            price: 2990.00,
            version: "Original",
            sellerName: "KENZO",
            productImageName: "kenzo",
            dateAdded: "13 may 2025"
        ),
        SavedProduct(
            name: "Carolina Herrera Good Girl",
            capacity: "80 ml",
            price: 3850.00,
            version: "Eau de Parfum",
            sellerName: "Carolina Herrera",
            productImageName: "goodgirl",
            dateAdded: "12 may 2025"
        ),
        SavedProduct(
            name: "Apple Watch Series 9",
            capacity: "41mm",
            price: 7999.00,
            version: "GPS",
            sellerName: "Apple",
            productImageName: "watch",
            dateAdded: "10 may 2025"
        )
    ]
    
    // ID del producto seleccionado (para el checkmark)
    @State private var selectedProductId: UUID?
    @State private var goToArrowView = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                            Spacer()
                            // Header
                            HStack {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                }
                                
                                Spacer()
                                
                                Text("Ver en Tienda")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    // Cart button action
                                }) {
                                    Image(systemName: "bag")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#D3008B"))
                
                // Main content
                VStack(alignment: .leading, spacing: 0) {
                    Text("Productos guardados para ver más tarde")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.vertical)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(savedProducts) { product in
                                productCard(product)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Botón de buscar producto en tienda
                    if selectedProductId != nil {
                        HStack{
                            Button(action: {
                                // Quitar action
                            }) {
                                Text("Quitar")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(4)
                            }
                            Button(action: {
                                goToArrowView = true
                            }) {
                                Text("Buscar Producto")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color(hex: "#D3008B"))
                                            .cornerRadius(4)
                            }
                            .padding()
                        }
                        
                        
                    }
                }
                .background(Color.gray.opacity(0.1))
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            // Navegación a ArrowView
            .background(
                NavigationLink(
                    destination: ArrowView(navigateToHomeViewRoot: .constant(false)),
                    isActive: $goToArrowView
                ) {
                    EmptyView()
                }
                    .navigationBarHidden(true)
            )
        }
    }
    
    // Tarjeta de producto con checkmark
    func productCard(_ product: SavedProduct) -> some View {
        HStack(alignment: .top) {
            // Checkmark column
            VStack {
                Circle()
                    .stroke(Color(hex: "#D3008B"), lineWidth: selectedProductId == product.id ? 0 : 1)
                    .background(
                        Circle()
                            .fill(selectedProductId == product.id ? Color(hex: "#D3008B") : Color.clear)
                    )
                    .frame(width: 22, height: 22)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(selectedProductId == product.id ? 1 : 0)
                    )
                Spacer()
            }
            .frame(width: 30)
            .padding(.top, 12)
            
            // Product details
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    // Product image
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(product.productImageName)
                                .resizable()
                                .scaledToFit()
                                .padding(8)
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name)
                            .font(.system(size: 16))
                            .lineLimit(2)
                        
                        Text("Talla: \(product.capacity)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Versión: \(product.version)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Vendido por: \(product.sellerName)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("Añadido: \(product.dateAdded)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text(String(format: "$%.2f", product.price))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#D3008B"))
                            .padding(.top, 2)
                    }
                    .padding(.leading, 8)
                    .padding(.vertical, 6)
                }
                .padding(.vertical, 8)
                
                // Separator
                Divider()
                    .background(Color.gray.opacity(0.3))
                
               
               
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            // Lógica para seleccionar solo un producto a la vez
            selectedProductId = product.id
        }
        .navigationBarHidden(true)
    }
}

// Extensión para color hex

struct VerDespuesEnTiendaView_Previews: PreviewProvider {
    static var previews: some View {
        VerDespuesEnTiendaView()
    }
}
