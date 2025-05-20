//
//  MapViewScreen.swift
//  UberAppSwiftUI
//
//  Created by XECE on 20.05.2025.
//
import SwiftUI
import MapKit

struct MapViewScreen: View {
    let city: String

    @State private var region = MKCoordinateRegion()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showCallButton = false

    @ObservedObject var rideViewModel = RideViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: annotationItem()) { coordinate in
                    MapAnnotation(coordinate: coordinate.coordinate) {
                        Circle()
                            .fill(Color.purple) // RENK DEĞİŞTİ 🔮
                            .frame(width: 24, height: 24)
                    }
                }
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { _ in
                            let center = region.center
                            selectedCoordinate = center
                            showCallButton = true
                        }
                )
                .onAppear {
                    if let coordinate = TurkishCities.coordinates[city] {
                        region = MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                        )
                    }
                }

                if showCallButton {
                    VStack {
                        Spacer()
                        Button("Call Taxi") {
                            if let coordinate = selectedCoordinate {
                                rideViewModel.callTaxi(at: coordinate)
                                showCallButton = false
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Passenger Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func annotationItem() -> [CoordinateWrapper] {
        guard let coordinate = selectedCoordinate else { return [] }
        return [CoordinateWrapper(coordinate: coordinate)]
    }

    struct CoordinateWrapper: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
}
