import SwiftUI

enum AppTheme {
    static func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "es_MX") // Puedes ajustarlo a tu país
        return f.string(from: NSNumber(value: value)) ?? "$\(value)"
    }
}
