import Foundation

struct RegisterTransactionUseCase {
    private let transactionRepo: TransactionRepositoryProtocol
    private let customerRepo: CustomerRepositoryProtocol

    init(transactionRepo: TransactionRepositoryProtocol, customerRepo: CustomerRepositoryProtocol) {
        self.transactionRepo = transactionRepo
        self.customerRepo = customerRepo
    }

    func execute(_ transaction: DebtTransaction, for customer: Customer) async throws {
        // 1. Validar según el tipo de transacción
        if transaction.type == .charge {
            // Cargo (fiado): verificar que no supere el límite de crédito
            let nextDebt = customer.currentDebt + transaction.amount
            if nextDebt > customer.creditLimit {
                throw NSError(domain: "CreditLimitError", code: 403,
                              userInfo: [NSLocalizedDescriptionKey: "El cliente superaría su límite de crédito."])
            }
        } else {
            // Abono (pago): verificar que no supere la deuda actual
            if transaction.amount > customer.currentDebt {
                throw NSError(domain: "PaymentError", code: 400,
                              userInfo: [NSLocalizedDescriptionKey: "El abono no puede superar la deuda actual."])
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
