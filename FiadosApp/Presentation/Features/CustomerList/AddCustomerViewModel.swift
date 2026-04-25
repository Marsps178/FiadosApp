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
        validateForm() == nil
    }
    
    func validateForm() -> String? {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "El nombre es obligatorio."
        }
        
        let cleanPhone = phone.trimmingCharacters(in: .whitespaces)
        if cleanPhone.count < 8 {
            return "El teléfono debe tener al menos 8 dígitos."
        }
        
        // Validar que solo contenga números
        let phoneRegex = "^[0-9]+$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: cleanPhone) {
            return "El teléfono solo debe contener números."
        }
        
        guard let amount = Double(limit), amount > 0 else {
            return "El límite de crédito debe ser mayor a 0."
        }
        return nil
    }
    
    @MainActor
    func saveCustomer() async {
        if let validationError = validateForm() {
            self.errorMessage = validationError
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let newCustomer = Customer(
            id: UUID().uuidString,
            name: name,
            phoneNumber: phone,
            creditLimit: Double(limit) ?? 0,
            currentDebt: 0 
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
