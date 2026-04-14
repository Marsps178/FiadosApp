import Foundation
import Observation

@Observable
class CustomerListViewModel {
    // Estado de la UI
    var customers: [Customer] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Dependencias (Inyectadas)
    private let repository: CustomerRepositoryProtocol
    
    init(repository: CustomerRepositoryProtocol) {
        self.repository = repository
    }
    
    // Filtro de búsqueda (HU-02)
    var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return customers
        } else {
            return customers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @MainActor
    func loadCustomers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.customers = try await repository.fetchCustomers()
            isLoading = false
        } catch {
            self.errorMessage = "Error al cargar clientes: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
