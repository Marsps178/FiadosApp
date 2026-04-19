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
        // FIX #8: Eliminado NavigationStack interno redundante.
        // .sheet ya provee su propio contexto de navegación en iOS 16+.
        // El stack anidado causaba conflictos en iPad y comportamiento inesperado.
        NavigationView {
            Form {
                Section(header: Text("Tipo de Operación")) {
                    Picker("Tipo", selection: $selectedType) {
                        Text("Fiado (Cargo)").tag(TransactionType.charge)
                        Text("Pago (Abono)").tag(TransactionType.credit)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(selectedType == .charge ? AppTheme.danger : AppTheme.success)
                }

                Section(header: Text("Detalles")) {
                    TextField("Monto ($)", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(selectedType == .charge ? AppTheme.danger : AppTheme.success)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10)

                    TextField("Concepto (ej. Pan, Leche, Pago semana)", text: $concept)
                        .font(.body)
                }

                if selectedType == .credit && (Double(amount) ?? 0) > viewModel.customer.currentDebt {
                    Section {
                        Text("El abono no puede superar la deuda actual de \(AppTheme.currency(viewModel.customer.currentDebt)).")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Registrar Movimiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirmar") {
                        if let value = Double(amount) {
                            Task {
                                await viewModel.addTransaction(amount: value, concept: concept, type: selectedType)
                                if viewModel.errorMessage == nil {
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                    dismiss()
                                }
                            }
                        }
                    }
                    .disabled(!isFormValid || viewModel.isLoading)
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
