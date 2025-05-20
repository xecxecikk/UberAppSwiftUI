//
//  PssengerHomeView.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//
import SwiftUI
import MapKit
import FirebaseAuth

struct PassengerHomeView: View {
    @StateObject private var viewModel = RideViewModel()
    @StateObject private var locationViewModel = LocationViewModel()
    
    @State private var selectedRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9208, longitude: 32.8541),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var rideAccepted = false
    @State private var driverCoordinate: CLLocationCoordinate2D?
    @State private var pickupLocation: CLLocationCoordinate2D?
    @State private var showSettings = false
    @State private var showTaxiInfo = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Passenger")
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
            
            ZStack {
                Map(
                    coordinateRegion: $selectedRegion,
                    showsUserLocation: true,
                    annotationItems: pickupLocation.map { [PickupAnnotation(coordinate: $0)] } ?? []
                ) { annotation in
                    MapPin(coordinate: annotation.coordinate, tint: .green)
                }
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            pickupLocation = selectedRegion.center
                        }
                )
                .frame(height: UIScreen.main.bounds.height / 2)
                .cornerRadius(12)
                
                if rideAccepted {
                    VStack {
                        Spacer()
                        Text("A driver is on the way!")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding()
                    }
                }
            }
            
            // ✅ Call Taxi button
            Button("Call Taxi") {
                if let location = pickupLocation {
                    Button("Call Taxi") {
                        viewModel.callTaxi(at: location)
                        withAnimation {
                            showTaxiInfo = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    if showTaxiInfo {
                        Text("Your request has been received. Your taxi will be on the way in a few seconds.")
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    Text("Long-press the map to set your pickup location.")
                        .foregroundColor(.gray)
                        .italic()
                        .padding(.bottom)
                }
                
                
                if viewModel.showActionButtons {
                    HStack(spacing: 20) {
                        Button("Cancel Ride") {
                            viewModel.cancelCurrentRide()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Complete Ride") {
                            viewModel.completeCurrentRide()
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
                if let location = locationViewModel.userLocation {
                    selectedRegion.center = location
                }
                viewModel.listenForAcceptedRide { accepted in
                    DispatchQueue.main.async {
                        self.rideAccepted = accepted
                        if !accepted {
                            self.showTaxiInfo = false
                            self.pickupLocation = nil
                        }
                    }
                }
                viewModel.listenForDriverLocation { coordinate in
                    self.driverCoordinate = coordinate
                }
            }
        }
    }
    
    struct PickupAnnotation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}
