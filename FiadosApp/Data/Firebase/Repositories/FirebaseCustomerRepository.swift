import Foundation
import FirebaseFirestore

class FirebaseCustomerRepository: CustomerRepositoryProtocol {
    private let db = FirebaseManager.shared.db
    private let collectionName = "customers"

    func fetchCustomers() async throws -> [Customer] {
        // Obtenemos los documentos de la colección "customers"
        let snapshot = try await db.collection(collectionName)
            .order(by: "name") // HU-02: Ordenados alfabéticamente
            .getDocuments()
        
        // Usamos el Mapper para convertir DTOs a Entities de Dominio
        return snapshot.documents.compactMap { document in
            try? document.data(as: CustomerDTO.self).toDomain()
        }
    }

    func saveCustomer(_ customer: Customer) async throws {
        let dto = customer.toDTO()
        // Si el cliente ya tiene ID, usamos setData, si no, addDocument
        try db.collection(collectionName).document(customer.id).setData(from: dto)
    }

    func updateCustomerDebt(customerId: String, newDebt: Double) async throws {
        try await db.collection(collectionName).document(customerId).updateData([
            "debt": newDebt
        ])
    }

    func updateCreditLimit(customerId: String, newLimit: Double) async throws {
        try await db.collection(collectionName).document(customerId).updateData([
            "limit": newLimit
        ])
    }
}
