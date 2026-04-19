import SwiftUI
import Observation

@Observable
final class RegisterViewModel {
    var email = ""
    var password = ""
    var confirmPassword = ""
    var isLoading = false
    var errorMessage: String? = nil
    
    private let registerUseCase: RegisterUseCase
    
    init(registerUseCase: RegisterUseCase) {
        self.registerUseCase = registerUseCase
    }
    
    var isFormValid: Bool {
        !email.isEmpty && password.count >= 6 && password == confirmPassword
    }
    
    func register() async {
        isLoading = true
        errorMessage = nil
        do {
            try await registerUseCase.execute(email: email, password: password)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
