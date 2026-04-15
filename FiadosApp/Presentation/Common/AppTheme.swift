import SwiftUI

enum AppTheme {
    // Colores semánticos
    static let primary     = Color.indigo
    static let danger      = Color.red
    static let success     = Color.green
    static let warning     = Color.orange
    static let cardBG      = Color(.secondarySystemBackground)

    // Radios de esquina unificados
    static let radiusCard  : CGFloat = 16
    static let radiusButton: CGFloat = 15

    static func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "es_MX") // Puedes ajustarlo a tu país
        return f.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
