//
//  TurkishCities.swift
//  UberAppSwiftUI
//
//  Created by XECE on 20.05.2025.
//

import CoreLocation

struct TurkishCities {
    static let list = [
        "Istanbul", "Ankara", "Izmir", "Bursa", "Antalya"
    ]

    static let coordinates: [String: CLLocationCoordinate2D] = [
        "Istanbul": CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784),
        "Ankara": CLLocationCoordinate2D(latitude: 39.9208, longitude: 32.8541),
        "Izmir": CLLocationCoordinate2D(latitude: 38.4192, longitude: 27.1287),
        "Bursa": CLLocationCoordinate2D(latitude: 40.1950, longitude: 29.0600),
        "Antalya": CLLocationCoordinate2D(latitude: 36.8969, longitude: 30.7133)
    ]
}
