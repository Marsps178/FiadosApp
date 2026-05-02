import SwiftUI

struct EditCreditLimitView: View {
    @Bindable var viewModel: CustomerDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var newLimit: String = ""
    @State private var showSuccessToast: Bool = false
    //comprobacion para hacer que el boton esuche una accion o no y para añadir estilo de no clicable
    private var isFormInvalid: Bool {
    Double(newLimit) == nil ||
    (Double(newLimit) ?? 0) < viewModel.customer.currentDebt ||
    Double(newLimit) == viewModel.customer.creditLimit ||
    viewModel.isLoading
}
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Card de Límite Actual
                        VStack(spacing: 8) {
                            Text("LÍMITE ACTUAL")
                                .font(.caption2.bold())
                                .tracking(1)
                                .foregroundColor(.secondary)
                            Text(AppTheme.currency(viewModel.customer.creditLimit))
                                .font(.title3.bold())
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        
                        // Card de Nuevo Límite
                        VStack(alignment: .leading, spacing: 20) {
                            Text("NUEVO LÍMITE DE CRÉDITO")
                                .font(.caption2.bold())
                                .tracking(1)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("S/")
                                        .font(.title2.bold())
                                        .foregroundColor(AppTheme.primary)
                                    
                                    TextField("0.00", text: $newLimit)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 44, weight: .bold, design: .rounded))
                                        .foregroundColor(AppTheme.primary)
                                        .fixedSize()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            
                            Text("No puedes reducirlo a un valor menor a su deuda activa (\(AppTheme.currency(viewModel.customer.currentDebt))).")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                        
                        if let value = Double(newLimit), value < viewModel.customer.currentDebt {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("El nuevo límite no puede ser menor a la deuda actual.")
                            }
                            .font(.caption.bold())
                            .foregroundColor(AppTheme.danger)
                            .padding()
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
                        if let value = Double(newLimit) {
                            Task {
                                await viewModel.updateCreditLimit(newLimit: value)
                                if viewModel.errorMessage == nil {
                                    HapticManager.notification(type: .success)
                                    withAnimation { showSuccessToast = true }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Actualizar Límite")
                        }
                    }
                    .primaryButtonStyle(isDisabled: isFormInvalid)
                    .disabled(isFormInvalid)
                    .padding()
                    .background(AppTheme.background)
                }
            }
            .navigationTitle("Editar Límite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .successToast(isPresented: $showSuccessToast, message: "Límite actualizado con éxito")
        }
    }
}
