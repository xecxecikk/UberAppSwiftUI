//
//  Ride.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//

import Foundation
import CoreLocation

struct Ride: Identifiable, Codable {
    let id: String
    let pickupLocation: CLLocationCoordinate2D

    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case pickup
    }

    enum PickupKeys: String, CodingKey {
        case latitude
        case longitude
    }

    // MARK: - Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)

        let pickupContainer = try container.nestedContainer(keyedBy: PickupKeys.self, forKey: .pickup)
        let latitude = try pickupContainer.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try pickupContainer.decode(CLLocationDegrees.self, forKey: .longitude)
        pickupLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // MARK: - Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)

        var pickupContainer = container.nestedContainer(keyedBy: PickupKeys.self, forKey: .pickup)
        try pickupContainer.encode(pickupLocation.latitude, forKey: .latitude)
        try pickupContainer.encode(pickupLocation.longitude, forKey: .longitude)
    }
}
