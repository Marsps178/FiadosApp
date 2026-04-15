import SwiftUI

struct AddTransactionView: View {
    @Bindable var viewModel: CustomerDetailViewModel // Usamos @Bindable para SwiftUI 17+
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
            Form {
                Section(header: Text("Tipo de Operación")) {
                    Picker("Tipo", selection: $selectedType) {
                        Text("Fiado (Cargo)").tag(TransactionType.charge)
                        Text("Pago (Abono)").tag(TransactionType.credit)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Detalles")) {
                    TextField("Monto ($)", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Concepto (ej. Pan, Leche, Pago semana)", text: $concept)
                }
                
                if selectedType == .credit && (Double(amount) ?? 0) > viewModel.customer.currentDebt {
                    Text("El abono no puede superar la deuda actual.")
                        .font(.caption)
                        .foregroundColor(.red)
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
