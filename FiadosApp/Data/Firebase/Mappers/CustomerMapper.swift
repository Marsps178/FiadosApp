import Foundation

extension CustomerDTO {
    // De Datos a Dominio
    func toDomain() -> Customer {
        Customer(
            id: self.id ?? UUID().uuidString,
            name: self.name,
            phoneNumber: self.phone,
            creditLimit: self.limit,
            currentDebt: self.debt
        )
    }
}

extension Customer {
    // De Dominio a Datos (para guardar)
    func toDTO() -> CustomerDTO {
        CustomerDTO(
            id: self.id,
            name: self.name,
            phone: self.phoneNumber,
            limit: self.creditLimit,
            debt: self.currentDebt
        )
    }
}
