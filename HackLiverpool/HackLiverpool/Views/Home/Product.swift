import Foundation

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var price: String // Ej: "$259.00"
    var imageName: String
    var description: String
    var sellerName: String
    var rating: Double
    var ordersCount: Int
}
