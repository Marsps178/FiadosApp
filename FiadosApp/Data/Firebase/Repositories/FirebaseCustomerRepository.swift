import Foundation
import FirebaseFirestore

class FirebaseCustomerRepository: CustomerRepositoryProtocol {
    private let db = FirebaseManager.shared.db
    private let collectionName = "customers"

    func fetchCustomers() async throws -> [Customer] {
        let snapshot = try await db.collection(collectionName)
            .order(by: "name")
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            do {
                let dto = try document.data(as: CustomerDTO.self)
                return dto.toDomain()
            } catch {

                print("❌ Error de decodificación en cliente \(document.documentID): \(error)")
                return nil
            }
        }
    }

    func saveCustomer(_ customer: Customer) async throws {
        let dto = customer.toDTO()
        try await db.collection(collectionName).document(customer.id).setData(from: dto)
    }

    func updateCustomerDebt(customerId: String, newDebt: Double) async throws {
        // FIX: updateData() lanza error si el documento no existe.
        // setData(merge:true) creaba silenciosamente documentos-fantasma
        // con solo el campo 'debt' cuando el customerId no concordaba.
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
        try await db.collection(collectionName).document(customerId).delete()
    }
}
