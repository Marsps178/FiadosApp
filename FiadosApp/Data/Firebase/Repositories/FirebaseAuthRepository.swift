import Foundation
import FirebaseAuth

final class FirebaseAuthRepository: AuthRepositoryProtocol {
    
    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func register(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func isUserAuthenticated() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func observeAuthState(completion: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { _, user in
            completion(user != nil)
        }
    }
    
    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
}
