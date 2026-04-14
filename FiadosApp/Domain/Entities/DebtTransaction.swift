import Foundation

enum TransactionType: String {
    case charge // Cargo (fiado)
    case credit // Abono (pago)
}

struct DebtTransaction: Identifiable, Equatable {
    let id: String
    let customerId: String
    let amount: Double
    let concept: String
    let date: Date
    let type: TransactionType
}
