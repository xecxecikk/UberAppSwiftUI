//
//  RideService.swift
//  UberAppSwiftUI
//
//  Created by XECE on 20.05.2025.
//

import Foundation
import CoreLocation
import FirebaseDatabaseInternal

final class RideService {
    private let db = FirebaseManager.shared.database

    func createRide(_ ride: Ride) {
        do {
            let data = try JSONEncoder().encode(ride)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                db.child("rides").child(ride.rideId).setValue(json)
            }
        } catch {
            print("Ride serialization failed: \(error)")
        }
    }

    func observeRides(completion: @escaping ([Ride]) -> Void) {
        db.child("rides").observe(.value) { snapshot in
            var rides: [Ride] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let data = try? JSONSerialization.data(withJSONObject: value),
                   let ride = try? JSONDecoder().decode(Ride.self, from: data) {
                    rides.append(ride)
                }
            }

            DispatchQueue.main.async {
                completion(rides.filter { $0.status == "requested" })
            }
        }
    }

    func acceptRide(_ rideId: String, driverId: String) {
        db.child("rides").child(rideId).updateChildValues([
            "driverId": driverId,
            "status": "accepted"
        ])
    }
}
