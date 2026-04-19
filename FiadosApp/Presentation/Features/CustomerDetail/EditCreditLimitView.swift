import SwiftUI

struct EditCreditLimitView: View {
    @Bindable var viewModel: CustomerDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var newLimit: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Ajustar Límite de Crédito ($)"), footer: Text("El límite actual es \(AppTheme.currency(viewModel.customer.creditLimit)). No puedes reducirlo a un valor menor a su deuda activa (\(AppTheme.currency(viewModel.customer.currentDebt))).")) {
                    TextField("Nuevo límite", text: $newLimit)
                        .keyboardType(.decimalPad)
                }
                
                if let value = Double(newLimit), value < viewModel.customer.currentDebt {
                    Text("El nuevo límite no puede ser menor a la deuda actual.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Editar Límite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        if let value = Double(newLimit) {
                            Task {
                                await viewModel.updateCreditLimit(newLimit: value)
                                if viewModel.errorMessage == nil {
                                    dismiss()
                                }
                            }
                        }
                    }
                    // FIX #5: También desactivar si el valor ingresado es igual al límite actual
                    .disabled(
                        Double(newLimit) == nil ||
                        (Double(newLimit) ?? 0) < viewModel.customer.currentDebt ||
                        Double(newLimit) == viewModel.customer.creditLimit ||
                        viewModel.isLoading
                    )
                }
            }
        }
    }
}
