import SwiftUI


struct HomeViewMejorado: View {
    @State private var selectedTab: String = "Lo nuevo"
    @State private var selectedProduct: Product?
    @State private var showSelectExperience = false
    @State private var navigateToSelectExperience = false
    @State private var navigateToHomeViewRoot = false
    @State private var floatingOffset: CGFloat = 0
    @State private var animateBounce = false
    @State private var buttonOffset: CGSize = .zero
    @State private var lastDragPosition: CGSize = .zero


    let perfumes = [
        Product(name: "Eau de parfum Kenzo Flower", price: "$2,990.00", imageName: "kenzo", description: "Perfume floral con notas de violeta y rosa.", sellerName: "Kenzo", rating: 4.5, ordersCount: 320),
        Product(name: "Lancôme La Vie Est Belle", price: "$4,350.00", imageName: "lancome", description: "Fragancia dulce con esencias de iris y jazmín.", sellerName: "Lancôme", rating: 5.0, ordersCount: 580),
        Product(name: "Carolina Herrera Good Girl", price: "$3,850.00", imageName: "goodgirl", description: "Fragancia elegante para ocasiones especiales.", sellerName: "Carolina Herrera", rating: 4.8, ordersCount: 410)
    ]

    let accessories = [
        Product(name: "Pulsera Lacoste dorada", price: "$1,250.00", imageName: "lacoste", description: "Pulsera elegante chapada en oro.", sellerName: "Lacoste", rating: 4.2, ordersCount: 150),
        Product(name: "Collar Swarovski Infinity", price: "$2,999.00", imageName: "swarovski", description: "Collar de cristales Swarovski con diseño infinito.", sellerName: "Swarovski", rating: 4.9, ordersCount: 260)
    ]

    let tech = [
        Product(name: "Apple Watch Series 9", price: "$7,999.00", imageName: "watch", description: "Smartwatch con monitor de salud y conectividad total.", sellerName: "Apple", rating: 5.0, ordersCount: 1000),
        Product(name: "Audífonos Bose", price: "$4,399.00", imageName: "bose", description: "Audífonos con cancelación activa de ruido.", sellerName: "Bose", rating: 4.7, ordersCount: 830)
    ]

    let fashion = [
        Product(name: "Vestido rojo satinado", price: "$2,300.00", imageName: "dress1", description: "Vestido elegante ideal para eventos nocturnos.", sellerName: "Liverpool", rating: 4.6, ordersCount: 190),
        Product(name: "Traje sastre negro", price: "$3,500.00", imageName: "suit", description: "Traje formal con corte moderno.", sellerName: "Liverpool", rating: 4.4, ordersCount: 270)
    ]

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer().frame(height: 180)
                        tabsView
                        bannerCarousel
                        productSection(title: "Fragancias para todos los gustos", products: perfumes)
                        productSection(title: "Accesorios para el gran día ✨", products: accessories)
                        productSection(title: "Tecnología que te acompaña", products: tech)
                        productSection(title: "Estilo para él y para ella", products: fashion)
                    }
                    .padding(.bottom, 90)
                }
                .background(Color(.systemGroupedBackground))

                VStack(spacing: 0) {
                    headerView
                }
                .background(Color(hex: "#D3008B"))
                .zIndex(1)

                NavigationLink(destination: SelectExperienceView(navigateToHomeViewRoot: $navigateToHomeViewRoot), isActive: $navigateToSelectExperience) {
                    EmptyView()
                }

                NavigationLink(
                    destination: selectedProduct.map { product in
                        let price = Double(product.price.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
                        return Products(
                            productImageName: product.imageName,
                            productName: product.name,
                            price: price,
                            description: product.description,
                            sellerName: product.sellerName,
                            sellerRating: product.rating,
                            ordersCount: product.ordersCount
                        )
                    },
                    isActive: Binding(get: { selectedProduct != nil }, set: { if !$0 { selectedProduct = nil } })
                ) {
                    EmptyView()
                }

                // Botón flotante
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showSelectExperience = true
                            self.navigateToSelectExperience = true
                        }) {
                            Image(systemName: "location.north.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(hex: "#D3008B"))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .offset(buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Movimiento suave con animación durante el arrastre
                                    withAnimation(.easeOut(duration: 0.15)) {
                                        buttonOffset = CGSize(
                                            width: lastDragPosition.width + value.translation.width,
                                            height: lastDragPosition.height + value.translation.height
                                        )
                                    }
                                }
                                .onEnded { _ in
                                    // Guardar la posición final sin animación
                                    lastDragPosition = buttonOffset
                                }
                        )
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }

    var headerView: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            HStack {
                Label("Elige una tienda", systemImage: "mappin.and.ellipse")
                    .foregroundColor(.white)
                Spacer()
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
                HStack(spacing: 16) {
                    Image(systemName: "heart")
                    Image(systemName: "bag")
                }
                .foregroundColor(.white)
            }
        }
        .padding()
    }

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
                            Text(product.price)
                                .foregroundColor(Color(hex: "#E10098"))
                                .font(.caption)
                                .bold()
                        }
                        .frame(width: 140)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
                        .onTapGesture {
                            selectedProduct = product
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}




// MARK: - Preview
#Preview {
    HomeViewMejorado()
}

