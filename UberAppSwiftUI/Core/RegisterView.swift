//
//  AuthView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//
import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @Binding var userRole: UserRole?
    @AppStorage("userRole") private var storedUserRole: String = ""

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedRole: UserRole = .passenger
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding(.top, 40)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Role", selection: $selectedRole) {
                    Text("Passenger").tag(UserRole.passenger)
                    Text("Driver").tag(UserRole.driver)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Button("Enter") {
                    registerAndProceed()
                }
                .buttonStyle(.borderedProminent)

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func registerAndProceed() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                Auth.auth().createUser(withEmail: email, password: password) { result, createError in
                    if let createError = createError {
                        errorMessage = createError.localizedDescription
                    } else {
                        proceedToHome()
                    }
                }
            } else {
                proceedToHome()
            }
        }
    }

    private func proceedToHome() {
        storedUserRole = selectedRole.rawValue
        userRole = selectedRole
    }
}
