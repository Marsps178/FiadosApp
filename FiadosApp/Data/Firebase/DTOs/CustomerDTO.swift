import Foundation
import FirebaseFirestore
struct CustomerDTO: Codable {
    @DocumentID var id: String?
    let name: String
    let phone: String
    let limit: Double
    let debt: Double
}
