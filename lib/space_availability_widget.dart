import 'package:flutter/material.dart';

/// A StatefulWidget that demonstrates reactive UI updates for shared space availability.
/// 
/// This widget shows how setState() triggers UI rebuilds when the state changes,
/// demonstrating the difference between static UI and state-driven UI updates.
/// It models real-world shared space transparency for gyms, halls, parking, etc.
class SpaceAvailabilityWidget extends StatefulWidget {
  /// Name of the shared space (e.g., "Gym", "Community Hall", "Parking Area")
  final String spaceName;
  
  /// Maximum capacity of the space
  final int maxCapacity;
  
  /// Initial occupancy count
  final int initialOccupancy;

  const SpaceAvailabilityWidget({
    super.key,
    required this.spaceName,
    this.maxCapacity = 20,
    this.initialOccupancy = 5,
  });

  @override
  State<SpaceAvailabilityWidget> createState() => _SpaceAvailabilityWidgetState();
}

class _SpaceAvailabilityWidgetState extends State<SpaceAvailabilityWidget> {
  /// Current occupancy count - this is the state that will trigger UI updates
  late int _currentOccupancy;

  @override
  void initState() {
    super.initState();
    // Initialize the occupancy from the widget's initial value
    _currentOccupancy = widget.initialOccupancy;
  }

  /// Increases occupancy by 1, but not above maximum capacity
  void _increaseOccupancy() {
    // setState() is the key method that triggers a UI rebuild
    // When called, Flutter marks this widget as "dirty" and schedules a rebuild
    // During rebuild, the build() method is called again with the new state
    setState(() {
      // Only increase if we haven't reached maximum capacity
      if (_currentOccupancy < widget.maxCapacity) {
        _currentOccupancy++;
      }
    });
  }

  /// Decreases occupancy by 1, but not below 0
  void _decreaseOccupancy() {
    // setState() again triggers a UI rebuild with the updated state
    // The UI will automatically reflect the new occupancy value
    setState(() {
      // Only decrease if we have people in the space
      if (_currentOccupancy > 0) {
        _currentOccupancy--;
      }
    });
  }

  /// Calculate availability percentage for visual indicator
  double get _availabilityPercentage => _currentOccupancy / widget.maxCapacity;

  /// Get color based on occupancy level
  Color get _occupancyColor {
    if (_availabilityPercentage < 0.5) {
      return Colors.green; // Low occupancy - plenty of space
    } else if (_availabilityPercentage < 0.8) {
      return Colors.orange; // Medium occupancy - getting crowded
    } else {
      return Colors.red; // High occupancy - nearly full
    }
  }

  @override
  Widget build(BuildContext context) {
    // This build method is called every time setState() is called
    // The UI automatically reflects the current state values
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Space name with icon
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.spaceName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Occupancy display with visual indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _occupancyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _occupancyColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  // Occupancy text
                  Text(
                    'Current Occupancy',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Main occupancy display
                  Text(
                    '$_currentOccupancy / ${widget.maxCapacity}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _occupancyColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Progress bar for visual representation
                  LinearProgressIndicator(
                    value: _availabilityPercentage,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(_occupancyColor),
                    minHeight: 8,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Availability status text
                  Text(
                    _availabilityPercentage >= 1.0
                        ? 'FULL'
                        : '${((1 - _availabilityPercentage) * 100).toInt()}% Available',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _occupancyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                // Decrease button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentOccupancy > 0 ? _decreaseOccupancy : null,
                    icon: const Icon(Icons.remove),
                    label: const Text('Decrease'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Increase button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentOccupancy < widget.maxCapacity 
                        ? _increaseOccupancy 
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Increase'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[400],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Educational note about setState()
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tap the buttons to see setState() in action! Each call triggers a UI rebuild.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example usage of SpaceAvailabilityWidget
/// 
/// This demonstrates how to use the widget in a Flutter app
class SpaceAvailabilityDemo extends StatelessWidget {
  const SpaceAvailabilityDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceSync - Availability Demo'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Gym example
            SpaceAvailabilityWidget(
              spaceName: 'Gym',
              maxCapacity: 25,
              initialOccupancy: 8,
            ),
            
            // Community Hall example
            SpaceAvailabilityWidget(
              spaceName: 'Community Hall',
              maxCapacity: 100,
              initialOccupancy: 45,
            ),
            
            // Parking Area example
            SpaceAvailabilityWidget(
              spaceName: 'Parking Area A',
              maxCapacity: 50,
              initialOccupancy: 42,
            ),
          ],
        ),
      ),
    );
  }
}
