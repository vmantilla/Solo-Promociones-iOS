import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        self.init(
            .sRGB,
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0,
            opacity: 1.0
        )
    }

    init?(colorString: String) {
        // Mapeo de nombres de colores estándar a `Color` del sistema
        let systemColors: [String: Color] = [
            "red": .red,
            "green": .green,
            "blue": .blue,
            "yellow": .yellow,
            "orange": .orange,
            "pink": .pink,
            "purple": .purple,
            "black": .black,
            "white": .white,
            "gray": .gray,
            "brown": .brown,
            "cyan": .cyan,
            "clear": .clear
        ]

        let colorLowercased = colorString.lowercased()
        
        if let systemColor = systemColors[colorLowercased] {
            self = systemColor
        } else if let hexColor = Color(hex: colorString) {
            self = hexColor
        } else {
            return nil
        }
    }
}
