import Foundation

struct RegisterTransactionUseCase {
    private let transactionRepo: TransactionRepositoryProtocol
    private let customerRepo: CustomerRepositoryProtocol

    init(transactionRepo: TransactionRepositoryProtocol, customerRepo: CustomerRepositoryProtocol) {
        self.transactionRepo = transactionRepo
        self.customerRepo = customerRepo
    }

    func execute(_ transaction: DebtTransaction, for customer: Customer) async throws {
        // 1. Si es un cargo (fiado), verificar límite
        if transaction.type == .charge {
            let nextDebt = customer.currentDebt + transaction.amount
            if nextDebt > customer.creditLimit {
                // Podrías crear un Error personalizado aquí
                throw NSError(domain: "CreditLimitError", code: 403, userInfo: [NSLocalizedDescriptionKey: "El cliente superaría su límite de crédito."])
            }
        }

        // 2. Guardar la transacción
        try await transactionRepo.addTransaction(transaction)

        // 3. Actualizar la deuda total del cliente
        let newDebt = transaction.type == .charge
            ? customer.currentDebt + transaction.amount
            : customer.currentDebt - transaction.amount
            
        try await customerRepo.updateCustomerDebt(customerId: customer.id, newDebt: newDebt)
    }
}
