//
//  Ride.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//

import Foundation
import CoreLocation

struct Ride: Identifiable, Codable {
    var id: String { rideId }
    let rideId: String
    let city: String
    let passengerId: String
    var driverId: String?
    var location: Coordinate
    var status: String // "requested", "accepted"
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}
