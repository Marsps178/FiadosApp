import Foundation
import Observation

@Observable
class AddCustomerViewModel {
    // Campos del formulario
    var name: String = ""
    var phone: String = ""
    var limit: String = "" // Usamos String para el Binding del TextField
    
    var isLoading: Bool = false
    var errorMessage: String?
    var shouldDismiss: Bool = false
    
    private let repository: CustomerRepositoryProtocol
    
    init(repository: CustomerRepositoryProtocol) {
        self.repository = repository
    }
    
    // Validación básica
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty &&
        (Double(limit) ?? 0) > 0
    }
    
    @MainActor
    func saveCustomer() async {
        guard isFormValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        let newCustomer = Customer(
            id: UUID().uuidString,
            name: name,
            phoneNumber: phone,
            creditLimit: Double(limit) ?? 0,
            currentDebt: 0 // Un cliente nuevo empieza con deuda 0
        )
        
        do {
            try await repository.saveCustomer(newCustomer)
            isLoading = false
            shouldDismiss = true
        } catch {
            isLoading = false
            errorMessage = "No se pudo guardar: \(error.localizedDescription)"
        }
    }
}
