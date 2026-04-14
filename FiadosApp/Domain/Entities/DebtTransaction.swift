import Foundation

enum TransactionType: String, Hashable{
    case charge // Cargo (fiado)
    case credit // Abono (pago)
}

struct DebtTransaction: Identifiable, Equatable, Hashable {
    let id: String
    let customerId: String
    let amount: Double
    let concept: String
    let date: Date
    let type: TransactionType
}
