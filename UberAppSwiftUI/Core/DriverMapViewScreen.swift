//
//  DriverMapViewScreen.swift
//  UberAppSwiftUI
//
//  Created by XECE on 20.05.2025.
//
import SwiftUI
import MapKit
import FirebaseDatabase
import FirebaseAuth

struct DriverMapViewScreen: View {
    let city: String
    @State private var region = MKCoordinateRegion()
    @State private var rideRequests: [Ride] = []
    @State private var selectedRide: Ride?

    private let db = Database.database().reference()

    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: rideRequests) { ride in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: ride.location.latitude, longitude: ride.location.longitude)) {
                        Circle()
                            .fill(Color.orange) 
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                selectedRide = ride
                            }
                    }
                }
                .onAppear {
                    if let coordinate = TurkishCities.coordinates[city] {
                        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
                    }

                    listenForCityRideRequests()
                }

                if let selected = selectedRide {
                    VStack {
                        Spacer()
                        Button("On My Way") {
                            acceptRide(selected)
                            selectedRide = nil
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Driver Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func listenForCityRideRequests() {
        db.child("rides").observe(.value) { snapshot in
            var newRides: [Ride] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let data = try? JSONSerialization.data(withJSONObject: value),
                   let ride = try? JSONDecoder().decode(Ride.self, from: data),
                   ride.status == "requested",
                   ride.city == city {
                    newRides.append(ride)
                }
            }

            self.rideRequests = newRides
        }
    }

    private func acceptRide(_ ride: Ride) {
        guard let driverId = Auth.auth().currentUser?.uid else { return }

        db.child("rides").child(ride.rideId).updateChildValues([
            "status": "accepted",
            "driverId": driverId
        ])
    }
}
