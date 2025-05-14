import SwiftUI

extension Color {
    static let liverpoolPink = Color(hex: "#D3008B")
        static let liverpoolDarkPink = Color(hex: "#B3007A")
        static let liverpoolLightGray = Color(hex: "#F5F5F5")
        static let liverpoolGray = Color(hex: "#888888")
        static let liverpoolRed = Color(hex: "#E23B30")
    init(hex: String) {
        
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255
        let blue = Double(rgbValue & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

