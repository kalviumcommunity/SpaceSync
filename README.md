# SpaceSync - Firebase Integration

## Project Overview
SpaceSync is a Flutter application designed for managing transparent access and occupancy for shared community spaces. This version integrates **Firebase Authentication** and **Cloud Firestore** to handle user management and real-time data syncing.

## Features
- **Firebase Authentication**: Secure email and password login and signup.
- **Cloud Firestore**:
  - Real-time synchronization of space availability.
  - User profile storage (Name, Email, CreatedAt).
- **Responsive UI**: optimized for mobile devices.

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or later)
- A Firebase project with Authentication (Email/Password) and Firestore enabled.

### Firebase Setup
1. **Create a Firebase Project**: Go to [console.firebase.google.com](https://console.firebase.google.com).
2. **Add Apps**: Add Android and iOS apps to your project.
3. **Configuration**:
   - Download `google-services.json` (for Android) and place it in `android/app/`.
   - Download `GoogleService-Info.plist` (for iOS) and place it in `ios/Runner/`.
4. **Enable Services**:
   - **Authentication**: Enable "Email/Password" provider.
   - **Firestore Database**: Create a database (start in Test Mode for development).

### Run the App
1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the app:
   ```bash
   flutter run
   ```

## Dependencies
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `provider`
- `firebase_storage`

## Code Snippets

### Authentication (Sign Up)
```dart
UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  email: email,
  password: password,
);
```

### Firestore (Save User Data)
```dart
await _usersCollection.doc(uid).set({
  'uid': uid,
  'email': email,
  'name': name ?? 'User',
  'createdAt': FieldValue.serverTimestamp(),
});
```

## Reflection
### How Firebase Simplifies Backend Management
Firebase provides a comprehensive suite of tools that eliminates the need for managing your own servers.
- **Authentication**: Handles complex flows like session management, encryption, and ID management out of the box.
- **Firestore**: Offers real-time data syncing, which is crucial for features like live occupancy updates, without writing complex WebSocket code.
- **Scalability**: automatically scales with your user base.

### Key Learnings
- Integrating Flutter with Firebase streams allows for reactive UI updates with minimal boilerplate.
- Separating services (Auth, Firestore) from UI logic (Screens) leads to cleaner, more maintainable code.
- Handling asynchronous streams properly (e.g., using `StreamBuilder`) is essential for a smooth user experience.
