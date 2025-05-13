import SwiftUI

struct AccountView: View {
    let userName = "Estrella Verdiguel"
    let appVersion = "8.2.3"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack {
                    Text("Mi cuenta")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 15)
                }
                .background(Color(hex: "#D3008B"))
                
                ScrollView {
                    VStack(spacing: 16) {
                        // User profile section
                        VStack(spacing: 0) {
                            Text(userName)
                                .font(.title2)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            MenuLinkRow(icon: "person.circle", text: "Datos y preferencias")
                            Divider().padding(.leading, 56)
                            MenuLinkRow(icon: "wallet.pass", text: "Mi cartera")
                            Divider().padding(.leading, 56)
                            MenuLinkRow(icon: "location", text: "Direcciones")
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                        
                        // Purchases section
                        VStack {
                            MenuLinkRow(icon: "bag", text: "Mis compras")
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                        
                        // Notifications and Wishlist
                        HStack(spacing: 16) {
                            MenuIconRow(icon: "bell", text: "Notificaciones")
                                .frame(maxWidth: .infinity)
                            
                            MenuIconRow(icon: "heart", text: "Wishlist")
                                .frame(maxWidth: .infinity)
                        }
                        NavigationLink(destination: VerDespuesEnTiendaView(
                           
                        )) {
                            MenuLinkRow(icon: "storefront", text: "Ver en Tienda")
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                        // Benefits section
                        VStack {
                            MenuLinkRow(icon: "tag", text: "Beneficios")
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                        
                        // Billing section
                        VStack {
                            MenuLinkRow(icon: "doc.text", text: "Facturación")
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                        
                        // Contact section
                        VStack {
                            MenuLinkRow(icon: "questionmark.circle", text: "Contacto")
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                        
                        // About section
                        VStack {
                            MenuLinkRow(icon: "info.circle", text: "Acerca de")
                            
                            Text("Versión: \(appVersion)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 16)
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1)
                    }
                    .padding(16)
                }
                .background(Color(UIColor.systemGray6))
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
        }
    }
}

struct MenuLinkRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
                .padding(.leading, 16)
            
            Text(text)
                .padding(.leading, 16)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 16)
        }
        .frame(height: 56)
        .background(Color.white)
    }
}

struct MenuIconRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
            
            Text(text)
                .font(.system(size: 16))
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 1)
    }
}


// Preview
struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
