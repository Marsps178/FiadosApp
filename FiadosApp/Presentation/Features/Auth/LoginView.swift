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
                VStack(alignment: .leading, spacing: 8) {
                    Text("Correo electrónico")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    TextField("ejemplo@tienda.com", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusButton)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radiusButton)
                                .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contraseña")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    SecureField("••••••••", text: $viewModel.password)
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusButton)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radiusButton)
                                .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(AppTheme.danger)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    Button(action: {
                        HapticManager.selection()
                        Task { await viewModel.login() }
                    }) {
                        Text("Iniciar Sesión")
                            .primaryButtonStyle(isDisabled: !viewModel.isFormValid)
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
