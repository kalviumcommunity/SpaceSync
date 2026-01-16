import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

class SpaceAvailabilityDemo extends StatelessWidget {
  const SpaceAvailabilityDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceSync Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getSpaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Seed data
                  await firestoreService.addSpace('Gym', 25, 5);
                  await firestoreService.addSpace('Community Hall', 100, 10);
                  await firestoreService.addSpace('Parking', 50, 48);
                },
                child: const Text('Initialize Demo Data'),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return SpaceListItem(
                docId: doc.id,
                name: data['name'] ?? 'Unknown',
                maxCapacity: data['maxCapacity'] ?? 0,
                currentOccupancy: data['currentOccupancy'] ?? 0,
              );
            },
          );
        },
      ),
    );
  }
}

class SpaceListItem extends StatelessWidget {
  final String docId;
  final String name;
  final int maxCapacity;
  final int currentOccupancy;

  const SpaceListItem({
    super.key,
    required this.docId,
    required this.name,
    required this.maxCapacity,
    required this.currentOccupancy,
  });

  double get _availabilityPercentage =>
      maxCapacity == 0 ? 0 : currentOccupancy / maxCapacity;

  Color get _occupancyColor {
    if (_availabilityPercentage < 0.5) return Colors.green;
    if (_availabilityPercentage < 0.8) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: _occupancyColor),
                const SizedBox(width: 8),
                Text(name, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _availabilityPercentage,
              color: _occupancyColor,
              backgroundColor: Colors.grey[200],
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text('$currentOccupancy / $maxCapacity Occupied'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentOccupancy > 0
                      ? () => firestoreService.updateOccupancy(
                            docId,
                            currentOccupancy - 1,
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100]),
                  child: const Text('Decrease'),
                ),
                ElevatedButton(
                  onPressed: currentOccupancy < maxCapacity
                      ? () => firestoreService.updateOccupancy(
                            docId,
                            currentOccupancy + 1,
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100]),
                  child: const Text('Increase'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
