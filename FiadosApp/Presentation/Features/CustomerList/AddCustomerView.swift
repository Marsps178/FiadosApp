import SwiftUI

struct AddCustomerView: View {
    @State var viewModel: AddCustomerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre completo", text: $viewModel.name)
                    TextField("Teléfono", text: $viewModel.phone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Configuración de Crédito")) {
                    TextField("Límite de crédito ($)", text: $viewModel.limit)
                        .keyboardType(.decimalPad)
                }
                
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error).foregroundColor(.red).font(.caption)
                    }
                }
            }
            .navigationTitle("Nuevo Cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Guardar Cliente") {
                            Task { await viewModel.saveCustomer() }
                        }
                        .fontWeight(.bold)
                        .disabled(!viewModel.isFormValid)
                    }
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
