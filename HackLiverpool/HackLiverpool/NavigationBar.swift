import SwiftUI
import MapKit

struct NavigationBar: View {
    @State private var selectedTab = 2
    
    var body: some View {
        // Eliminamos el NavigationView anidado del TabView
        TabView(selection: $selectedTab) {
            // Favorites/Heart Tab
            HomeViewMejorado()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
                .tag(0)
            Explore()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explorar")
                }
                .tag(1)
            Explore()
                .tabItem {
                    Image(systemName: "creditcard")
                    Text("Crédito y Ahorro")
                }
                .tag(2)
            Service()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Servicios")
                }
                .tag(3)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(4)
            
        }
        .accentColor(Color(hex: "#E10098"))
        .navigationBarBackButtonHidden(true)
    }
}





#Preview {
    NavigationBar()
}

