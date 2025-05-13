import SwiftUI

struct VerDespuesEnTiendaView: View {
    @State private var productName = "Eau de parfum Kenzo Flower para mujer"
    @State private var capacity = "100 ml"
    let price: Double = 2990.00
    let version = "Original"
    let sellerName = "KENZO"
    let productImageName = "kenzo"
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
                
                Text("Ver después en Tienda")
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
                Text("Creada el 13 may 2025")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                // Product card
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        // Product image
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(productImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(8)
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(productName)
                                .font(.system(size: 16))
                                .lineLimit(2)
                            
                            Text("Talla: \(capacity)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("Versión: \(version)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text("Vendido por: \(sellerName)")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text(String(format: "$%.2f", price))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#D3008B"))
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                
                            }
                        }
                        .padding(.leading, 8)
                        .padding(.vertical, 6)
                    }
                    .padding()
                    
                    // Botones
                    HStack(spacing: 12) {
                        Button(action: {
                            // Comprar action
                        }) {
                            Text("Quitar")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundColor(Color(hex: "#D3008B"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(hex: "#D3008B"), lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            // Mover a la bolsa action
                        }) {
                            Text("Ver Mapa")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "#D3008B"))
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .background(Color.gray.opacity(0.1))
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct VerDespuesEnTiendaView_Previews: PreviewProvider {
    static var previews: some View {
        VerDespuesEnTiendaView()
    }
}

