import SwiftUI

struct RegisterView: View {
    @Bindable var viewModel: RegisterViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Header
            VStack(spacing: 12) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.primary)
                    .padding(.bottom, 10)
                
                Text("Crear Cuenta")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(AppTheme.primaryDark)
                
                Text("Registra tu tienda para empezar a gestionar tus fiados de forma profesional.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 40)
            
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirmar Contraseña")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    SecureField("••••••••", text: $viewModel.confirmPassword)
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusButton)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radiusButton)
                                .stroke(Color.secondary.opacity(0.1), lineWidth: 1)
                        )
                }
                
                if !viewModel.password.isEmpty && viewModel.password != viewModel.confirmPassword {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Las contraseñas no coinciden")
                    }
                    .font(.caption.bold())
                    .foregroundColor(AppTheme.danger)
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
                        Task { await viewModel.register() }
                    }) {
                        Text("Crear Cuenta")
                            .primaryButtonStyle(isDisabled: !viewModel.isFormValid)
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
