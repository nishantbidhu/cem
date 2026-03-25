import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // STREAM: Listen to real-time auth changes
  Stream<User?> get user => _auth.authStateChanges();

  // GET CURRENT ID: Safely get the current student's UID
  String? get currentUserId => _auth.currentUser?.uid;

  // SIGN IN: Institutional Google Login
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Auth Error: $e");
      return null;
    }
  }

  // SIGN OUT
  Future<void> signOut() async => await _auth.signOut();
}