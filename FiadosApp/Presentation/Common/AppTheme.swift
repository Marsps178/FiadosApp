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
    // Modern "FinTech" Palette
    static let primary     = Color(hex: "#6366F1") // Indigo 500 (más vibrante)
    static let primaryDark = Color(hex: "#4F46E5") // Indigo 600
    static let danger      = Color(hex: "#EF4444") // Rose 500
    static let success     = Color(hex: "#10B981") // Emerald 500
    static let warning     = Color(hex: "#F59E0B") // Amber 500
    static let info        = Color(hex: "#3B82F6") // Blue 500
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [primary, primaryDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Backgrounds & Surfaces
    static let background  = Color(uiColor: .systemGroupedBackground)
    static let cardBG      = Color(uiColor: .secondarySystemGroupedBackground)
    static let surface     = Color(white: 1, opacity: 0.1)

    // Constants
    static let radiusCard  : CGFloat = 20 // Bordes más suaves
    static let radiusButton: CGFloat = 16

    static func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: AppSettingsManager.shared.currency.rawValue)
        return f.string(from: NSNumber(value: value)) ?? "\(AppSettingsManager.shared.currency.symbol) \(String(format: "%.2f", value))"
    }
}

// Custom ViewModifiers for Professional UI
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.cardBG)
            .cornerRadius(AppTheme.radiusCard)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

struct PrimaryButtonModifier: ViewModifier {
    var isDisabled: Bool = false
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isDisabled ? Color.gray.opacity(0.3) : AppTheme.primary)
            .cornerRadius(AppTheme.radiusButton)
            .shadow(color: isDisabled ? .clear : AppTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
    
    func primaryButtonStyle(isDisabled: Bool = false) -> some View {
        self.modifier(PrimaryButtonModifier(isDisabled: isDisabled))
    }
    
    func skeleton(isLoading: Bool) -> some View {
        self.modifier(SkeletonModifier(isLoading: isLoading))
    }
    
    func successToast(isPresented: Binding<Bool>, message: String) -> some View {
        self.modifier(SuccessToastModifier(isPresented: isPresented, message: message))
    }
}

struct SuccessToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        Text(message)
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(AppTheme.success.gradient)
                    .cornerRadius(30)
                    .shadow(color: AppTheme.success.opacity(0.4), radius: 10, x: 0, y: 5)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isPresented = false
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                .zIndex(100)
            }
        }
    }
}

struct SkeletonModifier: ViewModifier {
    var isLoading: Bool
    @State private var phase: Double = 0
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .redacted(reason: .placeholder)
                .overlay(
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.3), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 200)
                    .offset(x: -200 + (phase * 400))
                )
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
                .mask(content)
        } else {
            content
        }
    }
}

