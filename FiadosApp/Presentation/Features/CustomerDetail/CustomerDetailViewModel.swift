import Foundation
import Observation

@Observable
class CustomerDetailViewModel {
    var customer: Customer
    var transactions: [DebtTransaction] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Dependencias
    private let transactionRepo: TransactionRepositoryProtocol
    private let registerUseCase: RegisterTransactionUseCase
    
    init(customer: Customer,
         transactionRepo: TransactionRepositoryProtocol,
         registerUseCase: RegisterTransactionUseCase) {
        self.customer = customer
        self.transactionRepo = transactionRepo
        self.registerUseCase = registerUseCase
    }
    
    @MainActor
    func loadTransactions() async {
        isLoading = true
        do {
            self.transactions = try await transactionRepo.fetchTransactions(for: customer.id)
            isLoading = false
        } catch {
            self.errorMessage = "Error al cargar historial"
            isLoading = false
        }
    }
    
    @MainActor
    func addTransaction(amount: Double, concept: String, type: TransactionType) async {
        let newTransaction = DebtTransaction(
            id: UUID().uuidString,
            customerId: customer.id,
            amount: amount,
            concept: concept,
            date: Date(),
            type: type
        )
        
        do {
            try await registerUseCase.execute(newTransaction, for: customer)
            // Actualizamos el estado local para reflejar el cambio inmediato
            await loadTransactions()
            // Actualizar la deuda del objeto customer localmente
            let updatedDebt = type == .charge ? customer.currentDebt + amount : customer.currentDebt - amount
            self.customer = Customer(id: customer.id, name: customer.name, phoneNumber: customer.phoneNumber, creditLimit: customer.creditLimit, currentDebt: updatedDebt)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
