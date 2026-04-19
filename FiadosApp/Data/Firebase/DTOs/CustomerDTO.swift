import Foundation
import FirebaseFirestore

struct CustomerDTO: Codable {
    @DocumentID var id: String?
    let name: String
    let phone: String
    let limit: Double
    let debt: Double
    var userId: String? // Optional para soporte de migración
    // NOTA: No se define CodingKeys personalizado.
    // Esto permite que @DocumentID de FirebaseFirestoreSwift
    // mapee automáticamente el document ID al campo 'id'
    // durante fetchCustomers(). Sin este mapeo, toDomain()
    // ejecutaba id ?? UUID().uuidString → UUID nuevo en cada lectura.
}


