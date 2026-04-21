import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum AppTheme {
    // Colores semánticos basados en el Design System (Stitch)
    static let primary     = Color(hex: "#4F46E5") // Vibrant Indigo
    static let primaryDark = Color(hex: "#4338CA")
    static let danger      = Color(hex: "#EF4444") // Red
    static let success     = Color(hex: "#10B981") // Green
    static let warning     = Color(hex: "#F59E0B") // Orange
    
    // Backgrounds
    static let background  = Color(uiColor: .systemGroupedBackground) // Para el fondo de la app (off-white/light gray)
    static let cardBG      = Color(uiColor: .secondarySystemGroupedBackground) // Para tarjetas (suele ser blanco en light mode)

    // Radios de esquina unificados
    static let radiusCard  : CGFloat = 16
    static let radiusButton: CGFloat = 15

    static func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "es_PE") // Soles Peruanos
        return f.string(from: NSNumber(value: value)) ?? "S/ \(String(format: "%.2f", value))"
    }
}

// Custom ViewModifiers for consistent styling
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.cardBG)
            .cornerRadius(AppTheme.radiusCard)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}

