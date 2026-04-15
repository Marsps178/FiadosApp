import Foundation
import FirebaseFirestore

class FirebaseTransactionRepository: TransactionRepositoryProtocol {
    private let db = FirebaseManager.shared.db
    private let collectionName = "transactions"

    func fetchTransactions(for customerId: String) async throws -> [DebtTransaction] {
        let snapshot = try await db.collection(collectionName)
            .whereField("customerId", isEqualTo: customerId)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: TransactionDTO.self).toDomain()
        }
    }

    func addTransaction(_ transaction: DebtTransaction) async throws {
        let dto = transaction.toDTO()
        try await db.collection(collectionName).document(transaction.id).setData(from: dto)
    }
}
