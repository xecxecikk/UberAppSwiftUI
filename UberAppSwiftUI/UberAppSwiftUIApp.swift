//
//  UberAppSwiftUIApp.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//
import SwiftUI
import Firebase

@main
struct UberAppSwiftUIApp: App {
    @StateObject private var authVM = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRouterView()
                .environmentObject(authVM)
        }
    }
}
