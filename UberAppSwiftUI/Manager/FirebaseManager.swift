//
//  ConfirmedRide.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class FirebaseManager {
    static let shared = FirebaseManager()

    let auth: Auth
    let database: DatabaseReference

    private init() {
        self.auth = Auth.auth()
        self.database = Database.database().reference()
    }

    var currentUserId: String? {
        auth.currentUser?.uid
    }

    func logout() {
        try? auth.signOut()
    }
}
