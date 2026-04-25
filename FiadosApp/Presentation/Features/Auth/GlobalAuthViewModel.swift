import SwiftUI
import Observation

@Observable
final class GlobalAuthViewModel {
    var isAuthenticated: Bool = false
    var isCheckingAuth: Bool = true
    var userEmail: String? = nil
    
    private let observeUseCase: ObserveAuthStateUseCase
    private let logoutUseCase: LogoutUseCase
    private let getEmailUseCase: GetCurrentUserEmailUseCase
    
    init(observeUseCase: ObserveAuthStateUseCase, 
         logoutUseCase: LogoutUseCase,
         getEmailUseCase: GetCurrentUserEmailUseCase) {
        self.observeUseCase = observeUseCase
        self.logoutUseCase = logoutUseCase
        self.getEmailUseCase = getEmailUseCase
        startObserving()
    }
    
    private func startObserving() {
        observeUseCase.execute { [weak self] authenticated in
            self?.isAuthenticated = authenticated
            self?.isCheckingAuth = false
            if authenticated {
                self?.userEmail = self?.getEmailUseCase.execute()
            } else {
                self?.userEmail = nil
            }
        }
    }
    
    func logout() {
        do {
            try logoutUseCase.execute()
        } catch {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
    }
}
