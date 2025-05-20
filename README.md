# 🚖 UberSwiftUI – Realtime Firebase Taxi App

A full-featured taxi booking app built with SwiftUI and Firebase Realtime Database.  
Users can register as passengers or drivers. Passengers select a city and long-press the map to request a ride. Drivers can see requests as map annotations and accept them in real-time.

---

## ✨ Features

- ✅ Email & Password authentication (Firebase Auth)
- ✅ Realtime ride request handling with Firebase Realtime Database
- ✅ Passenger can select a city and request a ride from a specific location
- ✅ Driver can select a city and view nearby ride requests on the map
- ✅ Real-time map annotations show ride requests dynamically
- ✅ Ride status updates instantly upon acceptance

---

## 🔧 Tech Stack

- ✅ **SwiftUI** (iOS 16+)
- ✅ **Firebase Authentication**
- ✅ **Firebase Realtime Database**
- ✅ **MapKit (Apple Maps)**
- ✅ **MVVM architecture**
- ✅ State Management with `@State`, `@ObservedObject`, and `@EnvironmentObject`

---

## 🧭 App Flow

### Passenger:
1. Registers with role `"passenger"`
2. Selects a city
3. Enters map screen → long-presses to request a ride
4. Ride request is saved to Realtime Database

### Driver:
1. Registers with role `"driver"`
2. Selects a city
3. Enters map screen → sees red annotations for all pending rides
4. Taps one and presses `"On My Way"` to accept the ride

---

## 🚀 Getting Started

### 1. Setup Firebase
- Create a project at [Firebase Console](https://console.firebase.google.com/)
- Add an iOS app to your project
- Download `GoogleService-Info.plist` and add it to your Xcode project
- Enable **Authentication → Email/Password**
- Enable **Realtime Database**

  
