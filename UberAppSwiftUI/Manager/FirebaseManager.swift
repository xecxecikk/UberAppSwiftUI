//
//  ConfirmedRide.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private init() {}

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            completion(result != nil && error == nil)
        }
    }

    func register(email: String, password: String, userType: UserType, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let uid = result?.user.uid, error == nil else {
                completion(false)
                return
            }

            self.db.collection("users").document(uid).setData([
                "email": email,
                "userType": userType.rawValue
            ]) { error in
                completion(error == nil)
            }
        }
    }

    func currentUserID() -> String? {
        return auth.currentUser?.uid
    }

    func signOut() {
        try? auth.signOut()
    }
}
