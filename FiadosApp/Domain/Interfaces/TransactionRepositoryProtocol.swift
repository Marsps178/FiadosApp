import Foundation

protocol TransactionRepositoryProtocol {
    /// Obtiene todas las transacciones de un cliente específico, ordenadas por fecha
    func fetchTransactions(for customerId: String) async throws -> [DebtTransaction]
    
    /// Registra un nuevo cargo o abono
    func addTransaction(_ transaction: DebtTransaction) async throws
}
