import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseCustomerRepository: CustomerRepositoryProtocol {
    private let db = FirebaseManager.shared.db
    private let collectionName = "customers"

    func fetchCustomers() async throws -> [Customer] {
        guard let userId = Auth.auth().currentUser?.uid else {
            return []
        }
        
        let snapshot = try await db.collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .order(by: "name")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            do {
                let dto = try document.data(as: CustomerDTO.self)
                return dto.toDomain()
            } catch {

                print("Error de decodificación en cliente \(document.documentID): \(error)")
                return nil
            }
        }
    }

    func saveCustomer(_ customer: Customer) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])
        }
        var dto = customer.toDTO()
        dto.userId = userId
        try await db.collection(collectionName).document(customer.id).setData(from: dto)
    }

    func updateCustomerDebt(customerId: String, newDebt: Double) async throws {
        let docRef = db.collection("customers").document(customerId)
        try await docRef.updateData([
            "debt": newDebt
        ])
    }

    func updateCreditLimit(customerId: String, newLimit: Double) async throws {
        try await db.collection(collectionName).document(customerId).updateData([
            "limit": newLimit
        ])
    }
    
    func deleteCustomer(customerId: String) async throws {
        let transactionsSnapshot = try await db.collection("transactions")
            .whereField("customerId", isEqualTo: customerId)
            .getDocuments()
            
        let batch = db.batch()
        
        for doc in transactionsSnapshot.documents {
            batch.deleteDocument(doc.reference)
        }
        
        let customerRef = db.collection(collectionName).document(customerId)
        batch.deleteDocument(customerRef)
        
        try await batch.commit()
    }
}
