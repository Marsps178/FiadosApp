import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
struct CustomerDTO: Codable {
    @DocumentID var id: String?
    let name: String
    let phone: String
    let limit: Double
    let debt: Double
}
