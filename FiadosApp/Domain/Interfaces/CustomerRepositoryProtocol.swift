import Foundation

protocol CustomerRepositoryProtocol {
    /// Obtiene la lista completa de clientes desde la fuente de datos
    func fetchCustomers() async throws -> [Customer]
    
    /// Guarda un nuevo cliente
    func saveCustomer(_ customer: Customer) async throws
    
    /// Actualiza únicamente la deuda de un cliente tras una transacción
    func updateCustomerDebt(customerId: String, newDebt: Double) async throws
    
    /// Edita el límite de crédito de un cliente (HU-03)
    func updateCreditLimit(customerId: String, newLimit: Double) async throws
}
