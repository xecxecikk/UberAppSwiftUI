//
//  RideViewModel.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//

import Foundation
import FirebaseDatabase
import CoreLocation
import FirebaseAuth

final class RideViewModel: ObservableObject {
    @Published var selectedCity: String = ""
    @Published var rideRequests: [Ride] = []
    @Published var showActionButtons: Bool = false

    private let db = Database.database().reference()

    func selectCity(_ city: String) {
        selectedCity = city
    }

    func callTaxi(at coordinate: CLLocationCoordinate2D) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let rideId = UUID().uuidString
        let ride = Ride(
            rideId: rideId,
            city: selectedCity,
            passengerId: uid,
            driverId: nil,
            location: Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude),
            status: "requested"
        )

        do {
            let data = try JSONEncoder().encode(ride)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                db.child("rides").child(rideId).setValue(json)
            }
        } catch {
            print("Failed to encode ride")
        }
    }

    func listenForRides() {
        db.child("rides").observe(.value) { snapshot in
            var rides: [Ride] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let data = try? JSONSerialization.data(withJSONObject: value),
                   let ride = try? JSONDecoder().decode(Ride.self, from: data) {
                    if ride.status == "requested" || ride.status == "accepted" {
                        rides.append(ride)
                    }
                }
            }

            DispatchQueue.main.async {
                self.rideRequests = rides
                self.showActionButtons = !rides.isEmpty
            }
        }
    }

    func acceptRide(_ ride: Ride) {
        guard let driverId = Auth.auth().currentUser?.uid else { return }

        db.child("rides").child(ride.rideId).updateChildValues([
            "driverId": driverId,
            "status": "accepted"
        ])
    }

    func sendDriverLocation(for rideId: String, coordinate: CLLocationCoordinate2D) {
        let locationData: [String: Any] = [
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
        db.child("rides").child(rideId).child("driverLocation").setValue(locationData)
    }

    func listenForAcceptedRide(completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        db.child("rides").observe(.value) { snapshot in
            var isAccepted = false

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let passengerId = value["passengerId"] as? String,
                   let status = value["status"] as? String,
                   passengerId == uid {
                    isAccepted = (status == "accepted")
                    break
                }
            }

            DispatchQueue.main.async {
                completion(isAccepted)
            }
        }
    }

    func listenForDriverLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        db.child("rides").observe(.value) { snapshot in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let passengerId = value["passengerId"] as? String,
                   passengerId == uid,
                   let driverLat = (value["driverLocation"] as? [String: Any])?["latitude"] as? Double,
                   let driverLon = (value["driverLocation"] as? [String: Any])?["longitude"] as? Double {

                    let coord = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                    DispatchQueue.main.async {
                        completion(coord)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

    func completeRide(for passengerId: String) {
        db.child("rides").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let id = value["passengerId"] as? String,
                   id == passengerId {
                    self.db.child("rides").child(snap.key).removeValue()
                    DispatchQueue.main.async {
                        self.rideRequests.removeAll { $0.passengerId == passengerId }
                    }
                }
            }
        }
    }

    func cancelCurrentRide() {
        // isteğe bağlı: yolcu iptali
        print("Ride cancelled.")
    }

    func completeCurrentRide() {
        // kullanılmıyor, onun yerine yukarıdaki completeRide kullanılmalı
        print("Ride completed.")
    }
}
