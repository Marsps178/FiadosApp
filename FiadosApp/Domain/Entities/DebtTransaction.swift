import Foundation

enum TransactionType: String, Hashable{
    case charge // fiado
    case credit // pago
}

struct DebtTransaction: Identifiable, Equatable, Hashable {
    let id: String
    let customerId: String
    let amount: Double
    let concept: String
    let date: Date
    let type: TransactionType
}
