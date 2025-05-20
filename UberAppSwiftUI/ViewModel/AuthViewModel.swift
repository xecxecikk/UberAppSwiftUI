//
//  AuthViewModel.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    private let auth = Auth.auth()
    private let db = Database.database().reference()

    init() {
        getCurrentUser()
    }

    func register(email: String, password: String, role: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let uid = result?.user.uid, error == nil else { return }

            let user = User(uid: uid, email: email, role: role)
            self?.db.child("users").child(uid).setValue([
                "uid": uid,
                "email": email,
                "role": role
            ])
            self?.currentUser = user
        }
    }

    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let uid = result?.user.uid, error == nil else { return }
            self?.fetchUser(uid: uid)
        }
    }

    private func fetchUser(uid: String) {
        db.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any],
                  let email = data["email"] as? String,
                  let role = data["role"] as? String else { return }

            self.currentUser = User(uid: uid, email: email, role: role)
        }
    }

     func getCurrentUser() {
        guard let uid = auth.currentUser?.uid else { return }
        fetchUser(uid: uid)
    }

    func logout() {
        try? auth.signOut()
        currentUser = nil
    }
}
