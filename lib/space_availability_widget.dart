import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/mock_services.dart';
import 'models/space.dart';
import 'main.dart'; // To access useMockServices
import 'screens/space_details_screen.dart';

class SpaceAvailabilityDemo extends StatelessWidget {
  final bool isEmbedded;

  const SpaceAvailabilityDemo({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    // Dynamically choose service based on mode
    final dynamic firestoreService =
        useMockServices ? MockFirestoreService() : FirestoreService();

    final bodyContent = StreamBuilder<List<Space>>(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No spaces found. Start with demo data?"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Seed data matching React App's mock data
                    await firestoreService.addSpace(
                        'Fitness Center', 'dumbbell', 25, 8);
                    await firestoreService.addSpace(
                        'Swimming Pool', 'waves', 30, 15);
                    await firestoreService.addSpace(
                        'Community Hall', 'users', 50, 45);
                    await firestoreService.addSpace(
                        'Parking Area A', 'car', 60, 60); // Full
                    await firestoreService.addSpace(
                        'Café Lounge', 'coffee', 20, 12);
                    await firestoreService.addSpace(
                        'Library', 'book-open', 25, 18);
                  },
                  child: const Text('Initialize Demo Data'),
                ),
              ],
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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
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
    );

    if (isEmbedded) {
      return bodyContent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceSync Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
      body: bodyContent,
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
    if (_availabilityPercentage < 0.5)
      return const Color(0xFF10b981); // Success
    if (_availabilityPercentage < 0.8)
      return const Color(0xFFf59e0b); // Warning
    return const Color(0xFFef4444); // Error
  }

  IconData get _iconData {
    switch (space.iconName) {
      case 'dumbbell':
        return Icons.fitness_center;
      case 'waves':
        return Icons.pool;
      case 'users':
        return Icons.people;
      case 'car':
        return Icons.directions_car;
      case 'coffee':
        return Icons.local_cafe;
      case 'book-open':
        return Icons.local_library;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access service to update occupancy directly from card if needed,
    // or just rely on details screen. React app had "Decrease/Increase" nowhere on dashboard,
    // only details? No, wait, React app dashboard had simple cards.
    // Let's keep the quick actions on the card for convenience, but also allow tap to details.

    final dynamic firestoreService =
        useMockServices ? MockFirestoreService() : FirestoreService();

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpaceDetailsScreen(space: space),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _occupancyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_iconData, color: _occupancyColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(space.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                            '${space.currentOccupancy} / ${space.maxCapacity} people',
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _availabilityPercentage,
                color: _occupancyColor,
                backgroundColor: Colors.grey[100],
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: space.currentOccupancy > 0
                        ? () => firestoreService.updateOccupancy(
                            space.id, space.currentOccupancy - 1)
                        : null,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: space.currentOccupancy < space.maxCapacity
                        ? () => firestoreService.updateOccupancy(
                            space.id, space.currentOccupancy + 1)
                        : null,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text("+"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
