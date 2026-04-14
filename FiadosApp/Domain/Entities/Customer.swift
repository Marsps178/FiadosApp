import Foundation

struct Customer: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let phoneNumber: String
    let creditLimit: Double
    let currentDebt: Double
    
    var availableCredit: Double { creditLimit - currentDebt }
    
    var isCloseToLimit: Bool {
            currentDebt >= (creditLimit * 0.8)
        }
}
