import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/mock_services.dart';
import 'models/space.dart';
import 'main.dart'; // To access useMockServices

class SpaceAvailabilityDemo extends StatelessWidget {
  const SpaceAvailabilityDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Dynamically choose service based on mode
    final dynamic firestoreService =
        useMockServices ? MockFirestoreService() : FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceSync Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              if (useMockServices) {
                MockAuthService().signOut();
              } else {
                AuthService().signOut();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Space>>(
        stream: firestoreService.getSpaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final spaces = snapshot.data ?? [];

          if (spaces.isEmpty) {
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

          return Column(
            children: [
              if (useMockServices)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange[100],
                  child: const Text("DEMO MODE: Changes sync in-memory only",
                      textAlign: TextAlign.center),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: spaces.length,
                  itemBuilder: (context, index) {
                    final space = spaces[index];
                    return SpaceListItem(space: space);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SpaceListItem extends StatelessWidget {
  final Space space;

  const SpaceListItem({
    super.key,
    required this.space,
  });

  double get _availabilityPercentage =>
      space.maxCapacity == 0 ? 0 : space.currentOccupancy / space.maxCapacity;

  Color get _occupancyColor {
    if (_availabilityPercentage < 0.5) return Colors.green;
    if (_availabilityPercentage < 0.8) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final dynamic firestoreService =
        useMockServices ? MockFirestoreService() : FirestoreService();

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
                Text(space.name, style: Theme.of(context).textTheme.titleLarge),
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
            Text('${space.currentOccupancy} / ${space.maxCapacity} Occupied'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: space.currentOccupancy > 0
                      ? () => firestoreService.updateOccupancy(
                            space.id,
                            space.currentOccupancy - 1,
                          )
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100]),
                  child: const Text('Decrease'),
                ),
                ElevatedButton(
                  onPressed: space.currentOccupancy < space.maxCapacity
                      ? () => firestoreService.updateOccupancy(
                            space.id,
                            space.currentOccupancy + 1,
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
