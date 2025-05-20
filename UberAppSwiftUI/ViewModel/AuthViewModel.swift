//
//  AuthViewModel.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//

import Foundation
import FirebaseAuth

enum UserType {
    case driver
    case passenger
}

final class AuthViewModel: ObservableObject {
    @Published var isUserLoggedIn = false
    @Published var userType: UserType?

    func checkLoginStatus() {
        if let user = Auth.auth().currentUser {
            isUserLoggedIn = true
            // örnek: Firestore'dan userType alınabilir
            fetchUserType(uid: user.uid)
        } else {
            isUserLoggedIn = false
        }
    }

    func fetchUserType(uid: String) {
        // Firestore'dan userType çek (örnek amaçlı manuel set)
        self.userType = .driver // ya da .passenger
    }

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isUserLoggedIn = (result != nil)
                completion(result != nil)
            }
        }
    }

    func register(email: String, password: String, userType: UserType, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let uid = result?.user.uid {
                // Firestore'a kullanıcı bilgilerini kaydet
                self.userType = userType
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

