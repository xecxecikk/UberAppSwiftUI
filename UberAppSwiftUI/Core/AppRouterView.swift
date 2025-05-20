//
//  AppRouterView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//
import SwiftUI
import FirebaseAuth

struct AppRouterView: View {
    @AppStorage("userRole") private var storedUserRole: String = ""
    @State private var userRole: UserRole? = nil

    var body: some View {
        Group {
            if let role = userRole {
                switch role {
                case .driver:
                    DriverHomeView()
                case .passenger:
                    PassengerHomeView()
                }
            } else {
                RegisterView(userRole: $userRole)
            }
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                if let savedRole = UserRole(rawValue: storedUserRole) {
                    userRole = savedRole
                }
            }
        }
    }
}

enum UserRole: String, Codable {
    case driver
    case passenger
}
