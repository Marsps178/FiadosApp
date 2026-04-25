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
    
    enum SortOrder {
        case name, debt
    }
    
    var sortOrder: SortOrder = .name
    
    // Filtro de búsqueda
    var filteredCustomers: [Customer] {
        let filtered = searchText.isEmpty ? customers : customers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        switch sortOrder {
        case .name:
            return filtered.sorted { $0.name < $1.name }
        case .debt:
            return filtered.sorted { $0.currentDebt > $1.currentDebt }
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
    
    @MainActor
    func deleteCustomers(at offsets: IndexSet) async {
        for index in offsets {
            let customerId = filteredCustomers[index].id
            do {
                try await repository.deleteCustomer(customerId: customerId)
                if let idx = customers.firstIndex(where: { $0.id == customerId }) {
                    customers.remove(at: idx)
                }
            } catch {
                self.errorMessage = "No se pudo eliminar: \(error.localizedDescription)"
            }
        }
    }
}
