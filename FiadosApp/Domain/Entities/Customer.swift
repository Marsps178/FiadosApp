import Foundation

struct Customer: Identifiable, Equatable {
    let id: String
    let name: String
    let phoneNumber: String
    let creditLimit: Double
    let currentDebt: Double
    
    var availableCredit: Double { creditLimit - currentDebt }
}
