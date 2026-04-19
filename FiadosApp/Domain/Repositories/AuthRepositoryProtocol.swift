import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func logout() throws
    func isUserAuthenticated() -> Bool
    func observeAuthState(completion: @escaping (Bool) -> Void)
}
