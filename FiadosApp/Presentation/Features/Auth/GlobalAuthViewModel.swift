import SwiftUI
import Observation

@Observable
final class GlobalAuthViewModel {
    var isAuthenticated: Bool = false
    var isCheckingAuth: Bool = true
    
    private let observeUseCase: ObserveAuthStateUseCase
    private let logoutUseCase: LogoutUseCase
    
    init(observeUseCase: ObserveAuthStateUseCase, logoutUseCase: LogoutUseCase) {
        self.observeUseCase = observeUseCase
        self.logoutUseCase = logoutUseCase
        startObserving()
    }
    
    private func startObserving() {
        observeUseCase.execute { [weak self] authenticated in
            self?.isAuthenticated = authenticated
            self?.isCheckingAuth = false
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
