class Space {
  final String id;
  final String name;
  final int maxCapacity;
  final int currentOccupancy;

  Space({
    required this.id,
    required this.name,
    required this.maxCapacity,
    required this.currentOccupancy,
  });

  factory Space.fromMap(String id, Map<String, dynamic> data) {
    return Space(
      id: id,
      name: data['name'] ?? 'Unknown',
      maxCapacity: data['maxCapacity'] ?? 0,
      currentOccupancy: data['currentOccupancy'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'maxCapacity': maxCapacity,
      'currentOccupancy': currentOccupancy,
    };
  }
}
