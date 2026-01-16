import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _spacesCollection => _db.collection('spaces');

  // Stream of spaces
  Stream<QuerySnapshot> getSpaces() {
    return _spacesCollection.snapshots();
  }

  // Update occupancy
  Future<void> updateOccupancy(String spaceId, int newOccupancy) async {
    await _spacesCollection.doc(spaceId).update({
      'currentOccupancy': newOccupancy,
    });
  }

  // Add a new space (for setup)
  Future<void> addSpace(
      String name, int maxCapacity, int currentOccupancy) async {
    await _spacesCollection.add({
      'name': name,
      'maxCapacity': maxCapacity,
      'currentOccupancy': currentOccupancy,
    });
  }
}
