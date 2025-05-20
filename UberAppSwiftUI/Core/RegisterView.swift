//
//  AuthView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthVM()
    @State private var selectedCity = "İstanbul"

    var body: some View {
        VStack(spacing: 20) {
            TextField("E-posta", text: $viewModel.email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Şifre", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("İl Seçiniz", selection: $selectedCity) {
                ForEach(turkishCities, id: \.self) { city in
                    Text(city)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedCity) { viewModel.city = $0 }

            Button("Kayıt Ol") {
                Task {
                    await viewModel.register { success in
                        print(success ? "Kayıt Başarılı" : "Kayıt Hatası")
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Kayıt Ol")
    }
}
