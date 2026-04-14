import Foundation

struct CheckCreditLimitUseCase {
    func canAddAmount(_ amount: Double, to customer: Customer) -> Bool {
        return (customer.currentDebt + amount) <= customer.creditLimit
    }
}
