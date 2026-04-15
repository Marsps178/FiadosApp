import Foundation

enum AppError: LocalizedError {
    case creditLimitExceeded
    case paymentExceedsDebt
    case networkUnavailable
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .creditLimitExceeded:
            return "El cliente superaría su límite de crédito."
        case .paymentExceedsDebt:
            return "El abono no puede superar la deuda actual."
        case .networkUnavailable:
            return "Sin conexión. Verifica tu red."
        case .custom(let message):
            return message
        }
    }
}
