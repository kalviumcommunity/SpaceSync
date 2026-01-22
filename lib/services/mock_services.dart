import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import '../models/space.dart';

// --- MOCK AUTH SERVICE ---

class MockAuthService {
  final StreamController<User?> _userController = StreamController<User?>();
  static User? _currentUser;

  Stream<User?> get user => _userController.stream;

  MockAuthService() {
    // Start with no user or persisted user
    _userController.add(_currentUser);
  }

  Future<UserCredential?> signInAnonymously() async {
    _currentUser = MockUser(
        isAnonymous: true,
        uid: 'anon_user_${DateTime.now().millisecondsSinceEpoch}');
    _userController.add(_currentUser);
    return MockUserCredential(_currentUser!);
  }

  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    _currentUser = MockUser(
        email: email, uid: 'user_${DateTime.now().millisecondsSinceEpoch}');
    _userController.add(_currentUser);
    return MockUserCredential(_currentUser!);
  }

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    // Allow any login
    _currentUser = MockUser(
        email: email, uid: 'user_${DateTime.now().millisecondsSinceEpoch}');
    _userController.add(_currentUser);
    return MockUserCredential(_currentUser!);
  }

  Future<void> signOut() async {
    _currentUser = null;
    _userController.add(null);
  }
}

// --- MOCK FIRESTORE SERVICE ---

class MockFirestoreService {
  // Static map to hold data in memory across service instances
  static final StreamController<List<Space>> _spacesController =
      StreamController<List<Space>>.broadcast();
  static final List<Space> _spacesData = [];

  Stream<List<Space>> getSpaces() {
    // Emit current data immediately
    _emitSnapshot();
    return _spacesController.stream;
  }

  void _emitSnapshot() {
    _spacesController.add(List.from(_spacesData));
  }

  Future<void> updateOccupancy(String spaceId, int newOccupancy) async {
    final index = _spacesData.indexWhere((s) => s.id == spaceId);
    if (index != -1) {
      final oldSpace = _spacesData[index];
      _spacesData[index] = Space(
        id: oldSpace.id,
        name: oldSpace.name,
        maxCapacity: oldSpace.maxCapacity,
        currentOccupancy: newOccupancy,
      );
      _emitSnapshot(); // Trigger stream update!
    }
  }

  Future<void> addSpace(
      String name, int maxCapacity, int currentOccupancy) async {
    final id =
        'space_${DateTime.now().millisecondsSinceEpoch}_${_spacesData.length}';
    _spacesData.add(Space(
      id: id,
      name: name,
      maxCapacity: maxCapacity,
      currentOccupancy: currentOccupancy,
    ));
    _emitSnapshot();
  }
}

// --- MOCK CLASSES ---

class MockUser extends Mock implements User {
  final String _uid;
  final String? _email;
  final bool _isAnonymous;

  MockUser({String uid = 'test_uid', String? email, bool isAnonymous = false})
      : _uid = uid,
        _email = email,
        _isAnonymous = isAnonymous;

  @override
  String get uid => _uid;

  @override
  String? get email => _email;

  @override
  bool get isAnonymous => _isAnonymous;
}

class MockUserCredential extends Mock implements UserCredential {
  final User _user;
  MockUserCredential(this._user);

  @override
  User? get user => _user;
}
