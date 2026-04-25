import SwiftUI
import Observation

@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String? = nil
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    var isFormValid: Bool {
        !email.isEmpty && password.count >= 6
    }
    
    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            try await loginUseCase.execute(email: email, password: password)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
