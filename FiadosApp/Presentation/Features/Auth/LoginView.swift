import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    let container: DependencyContainer
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Logo / Título
            VStack(spacing: 12) {
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.primary)
                Text("FiadosApp")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.primaryDark)
                Text("Tu tienda bajo control.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Formulario
            VStack(spacing: 20) {
                TextField("Correo electrónico", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(AppTheme.radiusButton)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.radiusButton)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                
                SecureField("Contraseña", text: $viewModel.password)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(AppTheme.radiusButton)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.radiusButton)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(AppTheme.danger)
                        .multilineTextAlignment(.center)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        Task { await viewModel.login() }
                    }) {
                        Text("Iniciar Sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isFormValid ? AppTheme.primary : Color.gray)
                            .cornerRadius(AppTheme.radiusButton)
                            .shadow(color: viewModel.isFormValid ? AppTheme.primary.opacity(0.4) : .clear, radius: 10, x: 0, y: 5)
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Navegación a Registro
            NavigationLink(destination: RegisterView(viewModel: container.makeRegisterViewModel())) {
                HStack(spacing: 4) {
                    Text("¿No tienes cuenta?")
                        .foregroundColor(.secondary)
                    Text("Regístrate aquí")
                        .foregroundColor(AppTheme.primary)
                        .bold()
                }
                .padding(.bottom, 30)
            }
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}
