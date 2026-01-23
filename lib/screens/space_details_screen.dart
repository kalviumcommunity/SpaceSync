import 'package:flutter/material.dart';
import '../models/space.dart';

class SpaceDetailsScreen extends StatelessWidget {
  final Space space;

  const SpaceDetailsScreen({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    // Map icon names to IconData
    final IconData icon = _getIconData(space.iconName);
    final double occupancyPercentage =
        space.maxCapacity == 0 ? 0 : space.currentOccupancy / space.maxCapacity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Space Header Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _getStatusColor(occupancyPercentage)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon,
                              size: 32,
                              color: _getStatusColor(occupancyPercentage)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(space.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Chip(
                                    avatar: const Icon(Icons.people, size: 16),
                                    label: Text(
                                        '${space.currentOccupancy} / ${space.maxCapacity} people'),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  const Chip(
                                    avatar: Icon(Icons.access_time, size: 16),
                                    label: Text('Open 6 AM - 10 PM'),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Occupancy',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${(occupancyPercentage * 100).toInt()}% Full',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(occupancyPercentage))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: occupancyPercentage,
                      backgroundColor: Colors.grey[200],
                      color: _getStatusColor(occupancyPercentage),
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Availability Timeline
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 8),
                Text("Today's Availability",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text("Select a time slot to reserve your spot",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            _buildTimeSlotGrid(context, space.maxCapacity),

            const SizedBox(height: 24),

            // Reserve Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: space.currentOccupancy >= space.maxCapacity
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
                borderRadius: BorderRadius.circular(12),
                color: space.currentOccupancy >= space.maxCapacity
                    ? Colors.grey
                    : null,
              ),
              child: ElevatedButton(
                onPressed:
                    space.currentOccupancy >= space.maxCapacity ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  space.currentOccupancy >= space.maxCapacity
                      ? 'Currently Full - Check Back Later'
                      : 'Reserve This Space',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info Card
            Card(
              color: Colors.lightBlue[50],
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Booking is free and helps us manage capacity better. You can cancel anytime up to 30 minutes before your slot.",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid(BuildContext context, int maxCapacity) {
    // Mock time slots
    final slots = [
      {'time': '2:00 PM - 3:00 PM', 'occupancy': 5},
      {'time': '3:00 PM - 4:00 PM', 'occupancy': 8},
      {'time': '4:00 PM - 5:00 PM', 'occupancy': 12},
      {'time': '5:00 PM - 6:00 PM', 'occupancy': 20}, // Almost full
      {'time': '6:00 PM - 7:00 PM', 'occupancy': 15},
      {'time': '7:00 PM - 8:00 PM', 'occupancy': 10},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final occ = slot['occupancy'] as int;
        final isAvailable = occ < maxCapacity;
        final percentage = occ / maxCapacity;

        return InkWell(
          onTap: isAvailable ? () {} : null,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: isAvailable ? Colors.grey[300]! : Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(slot['time'] as String,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? _getStatusColor(percentage).withOpacity(0.1)
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Full',
                        style: TextStyle(
                            fontSize: 10,
                            color: isAvailable
                                ? _getStatusColor(percentage)
                                : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expected: $occ/$maxCapacity',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage,
                      color: _getStatusColor(percentage),
                      backgroundColor: Colors.grey[200],
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'dumbbell':
        return Icons.fitness_center;
      case 'waves':
        return Icons.pool;
      case 'users':
        return Icons.people;
      case 'car':
        return Icons.directions_car;
      case 'coffee':
        return Icons.local_cafe; // Coffee isn't standard, local_cafe is closest
      case 'book-open':
        return Icons.local_library;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(double percentage) {
    if (percentage < 0.5) return const Color(0xFF10b981); // Success
    if (percentage < 0.8) return const Color(0xFFf59e0b); // Warning
    return const Color(0xFFef4444); // Error
  }
}
