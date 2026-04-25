import Foundation

extension CustomerDTO {
    func toDomain() -> Customer {
        Customer(
            id: id ?? UUID().uuidString,
            name: name,
            phoneNumber: phone,
            creditLimit: limit,
            currentDebt: debt
        )
    }
}

extension Customer {
    func toDTO() -> CustomerDTO {
        CustomerDTO(
            id: id,
            name: name,
            phone: phoneNumber,
            limit: creditLimit,
            debt: currentDebt       
        )
    }
}
