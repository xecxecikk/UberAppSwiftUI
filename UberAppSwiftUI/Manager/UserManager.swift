//
//  UserManager.swift
//  UberAppSwiftUI
//
//  Created by XECE on 20.05.2025.
//

import Foundation

final class UserManager {
    private let db = FirebaseManager.shared.database

    func fetchUser(uid: String, completion: @escaping (User?) -> Void) {
        db.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any],
                  let email = data["email"] as? String,
                  let role = data["role"] as? String else {
                completion(nil)
                return
            }

            completion(User(uid: uid, email: email, role: role))
        }
    }

    func saveUser(_ user: User) {
        db.child("users").child(user.uid).setValue([
            "uid": user.uid,
            "email": user.email,
            "role": user.role
        ])
    }
}
