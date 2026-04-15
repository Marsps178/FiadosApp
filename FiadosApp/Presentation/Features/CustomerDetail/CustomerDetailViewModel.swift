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
    private let checkCreditUseCase: CheckCreditLimitUseCase
    
    init(customer: Customer,
         transactionRepo: TransactionRepositoryProtocol,
         registerUseCase: RegisterTransactionUseCase,
         checkCreditUseCase: CheckCreditLimitUseCase = CheckCreditLimitUseCase()) {
        self.customer = customer
        self.transactionRepo = transactionRepo
        self.registerUseCase = registerUseCase
        self.checkCreditUseCase = checkCreditUseCase
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
        isLoading = true
        errorMessage = nil

        // Validación rápida local antes del round-trip a Firebase
        if type == .charge && !checkCreditUseCase.canAddAmount(amount, to: customer) {
            self.errorMessage = "El cliente superaría su límite de crédito."
            isLoading = false
            return
        }

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

            // Actualizar deuda local con el mismo cálculo que el UseCase
            // max(0, ...) como red de protección ante posibles decimales flotantes
            let updatedDebt: Double
            if type == .charge {
                updatedDebt = customer.currentDebt + amount
            } else {
                updatedDebt = max(0, customer.currentDebt - amount)
            }
            self.customer = Customer(
                id: customer.id,
                name: customer.name,
                phoneNumber: customer.phoneNumber,
                creditLimit: customer.creditLimit,
                currentDebt: updatedDebt
            )

            // Recargar historial desde Firebase
            await loadTransactions()
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
