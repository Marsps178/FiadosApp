import SwiftUI

struct InitialsAvatar: View {
    let name: String
    var size: CGFloat = 45

    private var initials: String {
        name.split(separator: " ")
            .prefix(2)
            .compactMap { $0.first.map(String.init) }
            .joined()
            .uppercased()
    }

    // FIX #4: Color determinístico estable entre sesiones.
    // String.hashValue es aleatorio por ejecución desde Swift 4.2.
    // Usamos suma de bytes UTF-8, que siempre produce el mismo resultado.
    private var color: Color {
        let colors: [Color] = [.indigo, .purple, .teal, .orange, .pink, .cyan]
        let byteSum = name.utf8.reduce(0) { Int($0) + Int($1) }
        return colors[byteSum % colors.count]
    }

    var body: some View {
        Circle()
            .fill(color.opacity(0.15))
            .frame(width: size, height: size)
            .overlay(
                Text(initials)
                    .font(.system(size: size * 0.35, weight: .semibold))
                    .foregroundColor(color)
            )
    }
}
