import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        VStack {
            VStack {
                Image("logo") // Referencia al logo.png en Resources
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 20)
                
                Text("FiadosApp")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.primaryDark)
                    .padding(.top, 10)
                
                Text("Gestión Profesional de Deudas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .tracking(2)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
        .ignoresSafeArea()
    }
}
