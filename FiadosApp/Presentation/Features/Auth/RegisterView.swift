import SwiftUI

struct RegisterView: View {
    @Bindable var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Header
            VStack(spacing: 10) {
                Text("Crear Cuenta")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.primaryDark)
                Text("Registra tu tienda para empezar")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
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
                
                SecureField("Confirmar Contraseña", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(AppTheme.radiusButton)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.radiusButton)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                
                if !viewModel.password.isEmpty && viewModel.password != viewModel.confirmPassword {
                    Text("Las contraseñas no coinciden")
                        .font(.caption)
                        .foregroundColor(AppTheme.danger)
                }
                
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
                        HapticManager.selection()
                        Task { await viewModel.register() }
                    }) {
                        Text("Crear Cuenta")
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
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}
