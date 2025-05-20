//
//  DriverHomeView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//
import SwiftUI
import MapKit

struct DriverHomeView: View {
    @StateObject private var rideViewModel = RideViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var selectedRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9208, longitude: 32.8541),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Driver Map")
                .font(.largeTitle)
                .padding()

            Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true)
                .frame(height: UIScreen.main.bounds.height / 2)
                .cornerRadius(12)

            List(rideViewModel.rideRequests) { ride in
                VStack(alignment: .leading) {
                    Text("Passenger: \(ride.passengerId)")
                        .font(.headline)
                    Text("Location: \(ride.location.latitude), \(ride.location.longitude)")
                        .font(.subheadline)

                    HStack {
                        Button("Show on Map") {
                            selectedRegion.center = CLLocationCoordinate2D(
                                latitude: ride.location.latitude,
                                longitude: ride.location.longitude
                            )
                        }
                        .buttonStyle(.bordered)

                        Button("I'm on my way") {
                            rideViewModel.acceptRide(ride)
                            startSendingDriverLocation(for: ride.rideId)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            rideViewModel.listenForRides()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startSendingDriverLocation(for rideId: String) {
        timer?.invalidate() // stop old timer if exists
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            if let location = locationViewModel.userLocation {
                rideViewModel.sendDriverLocation(for: rideId, coordinate: location)
            }
        }
    }
}
