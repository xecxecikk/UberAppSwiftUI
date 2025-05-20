//
//  UserModel.swift
//  UberAppSwiftUI
//
//  Created by XECE on 18.05.2025.
//
import Foundation

struct User: Identifiable, Codable {
    var id: String { uid }
    let uid: String
    let email: String
    let role: String // "passenger" or "driver"
}
