import SwiftUI

struct AddTransactionView: View {
    @Bindable var viewModel: CustomerDetailViewModel
    @Environment(\.dismiss) var dismiss

    @State private var amount: String = ""
    @State private var concept: String = ""
    @State private var selectedType: TransactionType = .charge

    // Validación local de UI
    var isFormValid: Bool {
        guard let value = Double(amount), value > 0 else { return false }
        if concept.trimmingCharacters(in: .whitespaces).isEmpty { return false }

        // Regla HU-05: El abono no puede ser mayor a la deuda
        if selectedType == .credit && value > viewModel.customer.currentDebt {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Card de Selección de Tipo
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TIPO DE OPERACIÓN")
                                .font(.caption2.bold())
                                .tracking(1)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 0) {
                                Button(action: { selectedType = .charge }) {
                                    Text("Fiado (Cargo)")
                                        .font(.subheadline.bold())
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedType == .charge ? AppTheme.danger : Color.clear)
                                        .foregroundColor(selectedType == .charge ? .white : .primary)
                                }
                                
                                Button(action: { selectedType = .credit }) {
                                    Text("Pago (Abono)")
                                        .font(.subheadline.bold())
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(selectedType == .credit ? AppTheme.success : Color.clear)
                                        .foregroundColor(selectedType == .credit ? .white : .primary)
                                }
                            }
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(12)
                            .animation(.spring(response: 0.3), value: selectedType)
                        }
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        
                        // Card de Monto y Concepto
                        VStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("MONTO A REGISTRAR")
                                    .font(.caption2.bold())
                                    .tracking(1)
                                    .foregroundColor(.secondary)
                                
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("S/")
                                        .font(.title2.bold())
                                        .foregroundColor(selectedType == .charge ? AppTheme.danger : AppTheme.success)
                                    
                                    TextField("0.00", text: $amount)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 54, weight: .bold, design: .rounded))
                                        .foregroundColor(selectedType == .charge ? AppTheme.danger : AppTheme.success)
                                        .fixedSize()
                                }
                            }
                            .padding(.vertical, 10)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Concepto de la operación", text: $concept)
                                    .font(.body)
                                    .padding()
                                    .background(Color.secondary.opacity(0.05))
                                    .cornerRadius(12)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        let chips = selectedType == .charge ? ["Varios", "Semana", "Consumo", "Pan/Leche"] : ["Abono efectivo", "Yape/Plin", "Transferencia"]
                                        ForEach(chips, id: \.self) { chip in
                                            Button(action: {
                                                HapticManager.selection()
                                                concept = chip
                                            }) {
                                                Text(chip)
                                                    .font(.caption.bold())
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(selectedType == .charge ? AppTheme.danger.opacity(0.1) : AppTheme.success.opacity(0.1))
                                                    .foregroundColor(selectedType == .charge ? AppTheme.danger : AppTheme.success)
                                                    .cornerRadius(20)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(AppTheme.cardBG)
                        .cornerRadius(AppTheme.radiusCard)
                        
                        // Vista Previa de Impacto
                        if let value = Double(amount), value > 0 {
                            VStack(spacing: 12) {
                                Text("VISTA PREVIA DE SALDO")
                                    .font(.caption2.bold())
                                    .tracking(1)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Actual")
                                            .font(.caption)
                                        Text(AppTheme.currency(viewModel.customer.currentDebt))
                                            .font(.body.bold())
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        let newDebt = selectedType == .charge ? viewModel.customer.currentDebt + value : viewModel.customer.currentDebt - value
                                        Text("Nuevo Saldo")
                                            .font(.caption)
                                        Text(AppTheme.currency(newDebt))
                                            .font(.title3.bold())
                                            .foregroundColor(newDebt > viewModel.customer.creditLimit ? AppTheme.danger : .primary)
                                    }
                                }
                                
                                if selectedType == .charge && (viewModel.customer.currentDebt + value) > viewModel.customer.creditLimit {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        Text("¡Atención! Supera el límite de crédito")
                                    }
                                    .font(.caption.bold())
                                    .foregroundColor(AppTheme.danger)
                                    .padding(.top, 4)
                                }
                            }
                            .padding()
                            .background((selectedType == .charge && (viewModel.customer.currentDebt + value) > viewModel.customer.creditLimit) ? AppTheme.danger.opacity(0.05) : Color.secondary.opacity(0.05))
                            .cornerRadius(AppTheme.radiusCard)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding()
                }
                
                // Botón de Confirmación Flotante o al Final
                VStack {
                    Spacer()
                    Button(action: {
                        if let value = Double(amount) {
                            Task {
                                await viewModel.addTransaction(amount: value, concept: concept, type: selectedType)
                                if viewModel.errorMessage == nil {
                                    HapticManager.notification(type: .success)
                                    dismiss()
                                }
                            }
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Confirmar \(selectedType == .charge ? "Cargo" : "Abono")")
                        }
                    }
                    .primaryButtonStyle(isDisabled: !isFormValid || viewModel.isLoading)
                    .padding()
                    .background(AppTheme.background)
                }
            }
            .navigationTitle("Nuevo Movimiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onChange(of: selectedType) { _, newValue in
                HapticManager.selection()
                if newValue == .credit {
                    concept = "Abono a cuenta"
                } else if concept == "Abono a cuenta" {
                    concept = ""
                }
            }
            .alert("Error", isPresented: .init(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
