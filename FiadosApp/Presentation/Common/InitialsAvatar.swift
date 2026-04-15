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

    // Color determinístico basado en el nombre
    private var color: Color {
        let colors: [Color] = [.indigo, .purple, .teal, .orange, .pink, .cyan]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
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
