import Foundation

enum AppError: LocalizedError {
    case creditLimitExceeded
    case paymentExceedsDebt
    case networkUnavailable
    case invalidName
    case invalidPhone
    case invalidAmount
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .creditLimitExceeded:
            return "El cliente superaría su límite de crédito."
        case .paymentExceedsDebt:
            return "El abono no puede superar la deuda actual."
        case .networkUnavailable:
            return "Sin conexión. Verifica tu red."
        case .invalidName:
            return "El nombre no puede estar vacío."
        case .invalidPhone:
            return "El número de teléfono no es válido."
        case .invalidAmount:
            return "El monto debe ser mayor a cero."
        case .custom(let message):
            return message
        }
    }
}
