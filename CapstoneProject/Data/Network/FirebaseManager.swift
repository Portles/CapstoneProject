import FirebaseAuth
import FirebaseFirestore

final class FirebaseManager {
    static func fetchCurrentUserData(completion: @escaping (UserModel?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"]))
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists, let data = document.data() {
                let userModel = UserModel(uid: user.uid, data: data)
                completion(userModel, nil)
            } else {
                completion(nil, NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user data"]))
            }
        }
    }
    
    static func fetchBuyHistories(completion: @escaping (BuyHistory?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"]))
            return
        }
        
        let db = Firestore.firestore()
        
        let buyHistoryRef = db.collection("users").document(user.uid).collection("buyHistory").document(user.uid)
        
        buyHistoryRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let document = document, document.exists {
                do {
                    let buyHistory = try document.data(as: BuyHistory.self)
                    completion(buyHistory, nil)
                } catch let decodeError {
                    completion(nil, decodeError)
                }
            } else {
                completion(nil, NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "BuyHistory not found"]))
            }
        }
    }
    
    static func saveBuyHistory(_ buyHistory: BuyHistory, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"]))
            return
        }
        
        let db = Firestore.firestore()
        
        let buyHistoryRef = db.collection("users").document(user.uid).collection("buyHistory").document(buyHistory.id)
        
        do {
            try buyHistoryRef.setData(from: buyHistory) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } catch let error {
            completion(error)
        }
    }
}
