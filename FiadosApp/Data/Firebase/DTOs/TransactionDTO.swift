import Foundation
import FirebaseFirestore
struct TransactionDTO: Codable {
    @DocumentID var id: String?
    let customerId: String
    let amount: Double
    let concept: String
    let timestamp: Date
    let type: String
    var userId: String? // Optional para soporte de migración
}
