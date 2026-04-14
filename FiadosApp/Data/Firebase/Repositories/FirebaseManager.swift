import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    
    private init() {} // Singleton
}
