//
//  UserModel.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//
import Foundation

enum UserType: String, Codable {
    case driver
    case passenger
}

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let userType: UserType
}
