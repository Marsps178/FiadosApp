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
            // No seteamos isLoading = false aquí si logramos entrar porque el rootview
            // transicionará automáticamente al Dashboard (al detectar que isAuthenticated=true)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
