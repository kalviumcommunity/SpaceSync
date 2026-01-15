# 🏢 SpaceSync

**Transparent Access & Occupancy Management for Shared Community Spaces**

## 📌 Problem Statement

Residents in large housing communities often lack real-time visibility into the availability of shared spaces such as gyms, community halls, parking areas, and other amenities. This results in confusion, overcrowding, scheduling conflicts, and inefficient space usage.

**SpaceSync** solves this problem by making access and occupancy of shared spaces transparent, real-time, and easy to manage through a smart mobile application.

---

## 💡 Solution Overview

SpaceSync is a **cross-platform mobile application** built using **Flutter** and **Firebase** that enables residents and administrators to:

* View real-time occupancy of shared spaces
* Reserve or book available facilities
* Receive notifications about availability and updates
* Manage access securely using authentication
* Improve overall utilization of community resources

---

## 🎯 Key Features

* 🔐 **User Authentication** (Residents & Admins)
* 📊 **Real-Time Occupancy Tracking**
* 📅 **Space Booking & Reservation System**
* 🔔 **Push Notifications for Updates**
* 🏋️ **Shared Space Listings** (Gyms, Halls, Parking, etc.)
* 📱 **Responsive & Adaptive UI**
* 🌙 **Light & Dark Mode Support**
* 🛡️ **Secure Access with Firebase Rules**

---

## 🧩 Flutter Concepts

### StatelessWidget vs StatefulWidget

- **StatelessWidget**:
  - Immutable once built
  - Lightweight and efficient
  - Used for static content that doesn't change
  - Example: App bars, icons, text widgets

- **StatefulWidget**:
  - Maintains state that might change during the widget's lifetime
  - Rebuilds UI when internal state changes
  - Used for dynamic content and user interaction
  - Example: Forms, animations, counters

### Widget Tree & Reactive UI

Flutter builds UIs using a widget tree structure where:
- Each UI component is a widget
- Widgets can contain other widgets (composition)
- The framework efficiently updates only the widgets that change
- The widget tree is rebuilt when state changes, but Flutter's diffing algorithm ensures optimal performance
- This reactive approach enables smooth, 60fps animations and transitions

### Why Dart for Flutter?

Dart was chosen for Flutter because it:
- Compiles to native ARM code for high performance
- Supports both JIT (Just-In-Time) and AOT (Ahead-Of-Time) compilation
- Has a rich standard library and strong typing
- Supports both object-oriented and functional programming
- Enables hot reload for rapid development
- Provides excellent tooling and IDE support

## 🛠️ Tech Stack

### Frontend

* **Flutter**
* **Dart**
* Responsive UI using Widgets
* State Management (Provider / Riverpod)

### Backend & Cloud

* **Firebase Authentication**
* **Cloud Firestore** (Real-time Database)
* **Firebase Storage** (Media & Assets)
* **Firebase Cloud Messaging** (Push Notifications)
* **Cloud Functions** (Serverless Logic)

### Design & Tools

* **Figma** (UI/UX Design)
* **Flutter DevTools**
* **Android Studio & Emulator**

---

## 🧠 Sprint Alignment (Module 2)

This project is developed as part of:

> **Sprint #1: Building Smart Mobile Experiences with Flutter & Firebase**

The sprint focuses on designing and developing intelligent, scalable, and cloud-connected mobile applications using Flutter’s UI framework and Firebase’s backend services.

---

## 🧩 System Design

### High-Level Design (HLD)

* Flutter Mobile App (UI Layer)
* Firebase Authentication (User Management)
* Cloud Firestore (Spaces, Occupancy, Bookings)
* Firebase Cloud Messaging (Notifications)

### Low-Level Design (LLD)

* Stateless & Stateful Widgets
* Firestore Collections:

  * `users`
  * `spaces`
  * `bookings`
  * `occupancy_logs`
* Snapshot listeners for real-time updates
* Secure access using Firestore Rules

---

## 🔄 Core Functional Flow

1. User signs up / logs in using Firebase Auth
2. App fetches shared spaces from Firestore
3. Real-time occupancy is displayed using snapshot listeners
4. User books or checks availability
5. Firestore updates trigger live UI refresh
6. Notifications sent via FCM

---

## 📱 App Capabilities

* Multi-screen navigation using Navigator & Routes
* CRUD operations with Firestore
* Real-time synchronization
* Error handling, loaders & empty states
* Responsive layouts using MediaQuery & LayoutBuilder
* Animations & transitions for better UX

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for emulators)
- VS Code or Android Studio (as IDE)
- Git (for version control)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/spacesync.git
   cd spacesync
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   - For Android:
     ```bash
     flutter run -d chrome  # For web
     # OR
     flutter run           # For connected device/emulator
     ```
   - For iOS (macOS only):
     ```bash
     flutter run -d ios
     ```

4. **Build for Production**
   - Android APK:
     ```bash
     flutter build apk --release
     ```
   - iOS (macOS only):
     ```bash
     flutter build ios --release
     ```

### Development Workflow
- Use `flutter analyze` to check code quality
- Run tests with `flutter test`
- Use `flutter doctor` to verify your development environment
- For stateful hot reload during development:
  ```bash
  flutter run --hot
  ```

### Firebase Setup (Required for Full Functionality)
1. Create a new project on [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS/Web app to your Firebase project
3. Download the configuration files and place them in the appropriate directories
4. Enable required Firebase services (Authentication, Firestore, etc.)
5. Run `flutterfire configure` to set up Firebase for your Flutter app

---

## 🧪 Testing & Deployment

* Tested on Emulator & Physical Devices
* Release APK / App Bundle prepared
* Ready for Play Store deployment

---

## 📌 Future Enhancements

* Role-based access control (Admin dashboards)
* QR-based entry for booked spaces
* Analytics on space usage
* Google Maps integration for large communities
* IoT sensor integration for automatic occupancy updates

---

## 👥 Project Roles

**Name:** Vivan
**Role:** Member

**Name:** shahabas07
**Role:** Admin

---
