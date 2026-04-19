import Foundation

struct LoginUseCase {
    let repository: AuthRepositoryProtocol
    
    func execute(email: String, password: String) async throws {
        try await repository.login(email: email, password: password)
    }
}

struct RegisterUseCase {
    let repository: AuthRepositoryProtocol
    
    func execute(email: String, password: String) async throws {
        try await repository.register(email: email, password: password)
    }
}

struct LogoutUseCase {
    let repository: AuthRepositoryProtocol
    
    func execute() throws {
        try repository.logout()
    }
}

struct ObserveAuthStateUseCase {
    let repository: AuthRepositoryProtocol
    
    func execute(completion: @escaping (Bool) -> Void) {
        repository.observeAuthState(completion: completion)
    }
}
