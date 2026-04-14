import Foundation

extension CustomerDTO {
    func toDomain() -> Customer {
        Customer(
            id: id ?? UUID().uuidString,
            name: name,
            phoneNumber: phone,      // DTO 'phone' -> Domain 'phoneNumber'
            creditLimit: limit,      // DTO 'limit' -> Domain 'creditLimit'
            currentDebt: debt        // DTO 'debt'  -> Domain 'currentDebt'
        )
    }
}

extension Customer {
    func toDTO() -> CustomerDTO {
        CustomerDTO(
            id: id,
            name: name,
            phone: phoneNumber,     // Domain 'phoneNumber' -> DTO 'phone'
            limit: creditLimit,     // Domain 'creditLimit' -> DTO 'limit'
            debt: currentDebt       // Domain 'currentDebt' -> DTO 'debt'
        )
    }
}
