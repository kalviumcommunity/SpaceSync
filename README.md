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

## ⚡ Performance Architecture

### Flutter's Reactive Rendering Model

Flutter uses a **declarative reactive rendering** approach that ensures consistent 60fps performance across platforms:

* **Widget Tree Rebuild System**: When state changes, Flutter efficiently rebuilds only the affected widgets using the diffing algorithm
* **Skia Rendering Engine**: Direct-to-GPU rendering eliminates browser layer overhead, providing consistent frame rates
* **Impeller Display List**: Pre-compiles rendering commands for faster execution on mobile devices
* **Isolate-Based Architecture**: UI and background tasks run in separate isolates, preventing UI thread blocking

### Dart's Async Model for Smooth Performance

Dart's **single-threaded event loop** with async/await patterns ensures responsive UI:

* **Non-blocking Operations**: Network requests, database queries, and file I/O use async/await without freezing the UI
* **Microtask Queue**: Critical UI updates get priority over background computations
* **Future & Stream APIs**: Real-time data from Firestore uses streams for live updates without manual polling
* **Compute Isolates**: Heavy computations (data processing, encryption) run in separate isolates

### Cross-Platform Consistency

This architecture combination delivers:
- **Consistent 60fps** on both iOS and Android
- **Smooth animations** and transitions
- **Real-time updates** without UI lag
- **Efficient memory usage** through automatic widget disposal

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

## 🚀 Setup Instructions

1. Install Flutter SDK
2. Set up Android Studio & Emulator
3. Create a Firebase Project
4. Connect Firebase using FlutterFire CLI
5. Run the app using:

   ```bash
   flutter run
   ```

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
