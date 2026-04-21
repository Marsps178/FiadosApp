import SwiftUI

struct AddCustomerView: View {
    @State var viewModel: AddCustomerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Card de Información Personal
                        VStack(alignment: .leading, spacing: 20) {
                            Text("INFORMACIÓN PERSONAL")
                                .font(.caption2.bold())
                                .tracking(1)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 16) {
                                CustomTextField(
                                    label: "Nombre completo",
                                    placeholder: "ej. Juan Pérez",
                                    text: $viewModel.name,
                                    icon: "person.fill"
                                )
                                
                                CustomTextField(
                                    label: "Teléfono",
                                    placeholder: "987 654 321",
                                    text: $viewModel.phone,
                                    icon: "phone.fill",
                                    keyboard: .phonePad
                                )
                            }
                        }
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                        
                        // Card de Configuración de Crédito
                        VStack(alignment: .leading, spacing: 20) {
                            Text("CONFIGURACIÓN DE CRÉDITO")
                                .font(.caption2.bold())
                                .tracking(1)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                Text("LÍMITE DE CRÉDITO")
                                    .font(.caption.bold())
                                    .foregroundColor(.secondary)
                                
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("S/")
                                        .font(.title2.bold())
                                        .foregroundColor(AppTheme.primary)
                                    
                                    TextField("0.00", text: $viewModel.limit)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 44, weight: .bold, design: .rounded))
                                        .foregroundColor(AppTheme.primary)
                                        .fixedSize()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                        }
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                        
                        if let error = viewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(error)
                            }
                            .font(.caption.bold())
                            .foregroundColor(AppTheme.danger)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppTheme.danger.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
                
                // Botón de Acción
                VStack {
                    Spacer()
                    Button(action: {
                        HapticManager.selection()
                        Task { await viewModel.saveCustomer() }
                    }) {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Guardar Nuevo Cliente")
                        }
                    }
                    .primaryButtonStyle(isDisabled: !viewModel.isFormValid || viewModel.isLoading)
                    .padding()
                    .background(AppTheme.background)
                }
            }
            .navigationTitle("Nuevo Cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onChange(of: viewModel.shouldDismiss) { _, newValue in
                if newValue { 
                    HapticManager.notification(type: .success)
                    dismiss() 
                }
            }
        }
    }
}

struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption.bold())
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.primary)
                    .frame(width: 20)
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboard)
            }
            .padding()
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
        }
    }
}
