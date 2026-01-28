import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/space.dart';

class FirestoreService {
  // Lazy access to instance
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _spacesCollection => _db.collection('spaces');

  // Stream of spaces
  Stream<List<Space>> getSpaces() {
    return _spacesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Space.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update occupancy
  Future<void> updateOccupancy(String spaceId, int newOccupancy) async {
    await _spacesCollection.doc(spaceId).update({
      'currentOccupancy': newOccupancy,
    });
  }

  // Add a new space (for setup)
  Future<void> addSpace(String name, String iconName, int maxCapacity,
      int currentOccupancy) async {
    await _spacesCollection.add({
      'name': name,
      'iconName': iconName,
      'maxCapacity': maxCapacity,
      'currentOccupancy': currentOccupancy,
    });
  }

  // Collection reference for users
  CollectionReference get _usersCollection => _db.collection('users');

  // Save user data
  Future<void> saveUserData(String uid, String email, String? name) async {
    await _usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name ?? 'User',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user data stream
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots();
  }
}
