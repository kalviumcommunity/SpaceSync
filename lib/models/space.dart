class Space {
  final String id;
  final String name;
  final String iconName;
  final int maxCapacity;
  final int currentOccupancy;

  Space({
    required this.id,
    required this.name,
    required this.iconName,
    required this.maxCapacity,
    required this.currentOccupancy,
  });

  factory Space.fromMap(String id, Map<String, dynamic> data) {
    return Space(
      id: id,
      name: data['name'] ?? 'Unknown',
      iconName: data['iconName'] ?? 'help', // Default to generic icon
      maxCapacity: data['maxCapacity'] ?? 0,
      currentOccupancy: data['currentOccupancy'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconName': iconName,
      'maxCapacity': maxCapacity,
      'currentOccupancy': currentOccupancy,
    };
  }
}
