//
//  RideViewModel.swift
//  UberAppSwiftUI
//
//  Created by XECE on 19.05.2025.
//

import Foundation
import Combine

final class RideViewModel: ObservableObject {
    @Published var rides: [Ride] = []

    init() {
        fetchRides()
    }

    private func fetchRides() {
        RideManager.shared.listenForRides { [weak self] rides in
            DispatchQueue.main.async {
                self?.rides = rides
            }
        }
    }
}
