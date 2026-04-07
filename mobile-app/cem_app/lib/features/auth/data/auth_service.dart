
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // STREAM: Listen to real-time auth changes
  Stream<User?> get user => _auth.authStateChanges();

  // GET CURRENT ID: Safely get the current student's UID
  String? get currentUserId => _auth.currentUser?.uid;

  // SIGN OUT
  Future<void> signOut() async => await _auth.signOut();
}