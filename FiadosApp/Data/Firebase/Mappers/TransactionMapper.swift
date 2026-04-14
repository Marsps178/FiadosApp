import Foundation

extension TransactionDTO {
    func toDomain() -> DebtTransaction {
        DebtTransaction(
            id: self.id ?? UUID().uuidString,
            customerId: self.customerId,
            amount: self.amount,
            concept: self.concept,
            date: self.timestamp,
            type: TransactionType(rawValue: self.type) ?? .charge
        )
    }
}

extension DebtTransaction {
    func toDTO() -> TransactionDTO {
        TransactionDTO(
            id: nil,
            customerId: self.customerId,
            amount: self.amount,
            concept: self.concept,
            timestamp: self.date,
            type: self.type.rawValue
        )
    }
}
