import SwiftUI

struct HomeView: View {
    @State private var selectedTab: String = "Lo nuevo"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    tabsView
                    bannerCarousel
                    productSection(title: "Fragancias para todos los gustos", products: samplePerfumes)
                    productSection(title: "Accesorios para el gran día ✨", products: sampleAccessories)
                    productSection(title: "Tecnología que te acompaña", products: sampleTech)
                    productSection(title: "Estilo para él y para ella", products: sampleFashion)
                }
                .padding(.bottom, 90)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }

    // MARK: Header
    var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Label("Elige una tienda", systemImage: "mappin.and.ellipse")
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 16) {
                    Image(systemName: "heart")
                    Image(systemName: "bag")
                }
                .foregroundColor(.white)
            }

            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar por producto, marca y más", text: .constant(""))
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(hex: "#D3008B"))
    }

    // MARK: Tabs
    var tabsView: some View {
        HStack(spacing: 0) {
            ForEach(["Lo nuevo", "Para ti"], id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    Text(tab)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedTab == tab ? Color(hex: "#E10098") : Color.white)
                        .foregroundColor(selectedTab == tab ? .white : .black)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGray5))
        .cornerRadius(14)
        .padding(.horizontal)
    }

    // MARK: Carrusel
    var bannerCarousel: some View {
        TabView {
            ForEach(1..<3) { i in
                Image("liverpool\(i)")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 280)
                    .clipped()
                    .padding(.horizontal)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 280)
    }

    // MARK: Productos
    func productSection(title: String, products: [Product]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("Ver más")
                    .foregroundColor(Color(hex: "#E10098"))
                    .font(.subheadline)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        VStack(alignment: .leading, spacing: 6) {
                            Image(product.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .cornerRadius(10)
                            Text(product.name)
                                .font(.footnote)
                                .lineLimit(2)
                            Text(product.priceRange)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        .frame(width: 140)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Modelo y Ejemplos
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let priceRange: String
}

let samplePerfumes = [
    Product(name: "Eau de parfum Kenzo Flower", imageName: "kenzo", priceRange: "$850 - $2,990"),
    Product(name: "Lancôme La Vie Est Belle", imageName: "lancome", priceRange: "$1,930 - $4,350"),
    Product(name: "Carolina Herrera Good Girl", imageName: "goodgirl", priceRange: "$1,100 - $3,850")
]

let sampleAccessories = [
    Product(name: "Pulsera Lacoste dorada", imageName: "lacoste", priceRange: "$1,250"),
    Product(name: "Collar Swarovski Infinity", imageName: "swarovski", priceRange: "$2,999")
]

let sampleTech = [
    Product(name: "Apple Watch Series 9", imageName: "watch", priceRange: "$7,999"),
    Product(name: "Audífonos Bose", imageName: "bose", priceRange: "$4,399")
]

let sampleFashion = [
    Product(name: "Vestido rojo satinado", imageName: "dress1", priceRange: "$2,300"),
    Product(name: "Traje sastre negro", imageName: "suit", priceRange: "$3,500")
]

// MARK: - Extensión para color Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") { scanner.currentIndex = scanner.string.index(after: scanner.currentIndex) }

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255
        let blue = Double(rgbValue & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    HomeView()
}
