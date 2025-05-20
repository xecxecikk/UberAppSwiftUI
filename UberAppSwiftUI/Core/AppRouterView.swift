//
//  AppRouterView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//
import SwiftUI

struct AppRouterView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.isUserLoggedIn {
                if authVM.userType == .driver {
                    DriverHomeView()
                } else {
                    PassengerHomeView()
                }
            } else {
                LoginView()
            }
        }
        .onAppear {
            authVM.checkLoginStatus()
        }
    }
}
