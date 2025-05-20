//
//  DriverHomeView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//
import SwiftUI
import MapKit
import FirebaseAuth

struct DriverHomeView: View {
    @StateObject private var rideViewModel = RideViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    @State private var selectedRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9208, longitude: 32.8541),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var timer: Timer?
    @State private var showSettings = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Text("Driver Map")
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        .padding()
                }
            }
            .padding([.horizontal, .top])

            Map(coordinateRegion: $selectedRegion, showsUserLocation: true)
                .frame(height: UIScreen.main.bounds.height / 2)
                .cornerRadius(12)

            List(rideViewModel.rideRequests) { ride in
                VStack(alignment: .leading) {
                    Text("Passenger ID: \(ride.passengerId)")
                        .font(.headline)
                    Text("Pickup Location: \(ride.location.latitude), \(ride.location.longitude)")
                        .font(.subheadline)

                    HStack(spacing: 16) {
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
                .padding(.vertical, 6)
            }

            if rideViewModel.showActionButtons {
                HStack(spacing: 20) {
                    Button("Cancel Ride") {
                        rideViewModel.cancelCurrentRide()
                    }
                    .buttonStyle(.bordered)

                    Button("Complete Ride") {
                        if let ride = rideViewModel.rideRequests.first {
                            rideViewModel.completeRide(for: ride.passengerId)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSettings) {
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding()
                Button(action: {
                    try? Auth.auth().signOut()
                    dismiss()
                }) {
                    Text("Log Out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .onAppear {
            rideViewModel.listenForRides()
            if let location = locationViewModel.userLocation {
                selectedRegion.center = location
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startSendingDriverLocation(for rideId: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            if let location = locationViewModel.userLocation {
                rideViewModel.sendDriverLocation(for: rideId, coordinate: location)
            }
        }
    }
}
