import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/mock_services.dart';
import '../space_availability_widget.dart';
import '../main.dart'; // To access useMockServices

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (useMockServices) {
      // In mock mode, just show the demo widget as we don't have real user data mapping
      return const SpaceAvailabilityDemo();
    }

    final user = FirebaseAuth.instance.currentUser;
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: user != null ? firestoreService.getUserStream(user.uid) : null,
          builder: (context, snapshot) {
            String welcomeText = "Welcome";
            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data.containsKey('name')) {
                welcomeText = "Welcome, ${data['name']}";
              } else if (user?.email != null) {
                welcomeText = "Welcome, ${user!.email!.split('@')[0]}";
              }
            }
            return Text(welcomeText, style: const TextStyle(fontSize: 18));
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
            },
          ),
        ],
      ),
      body: const SpaceAvailabilityDemo(isEmbedded: true),
    );
  }
}
