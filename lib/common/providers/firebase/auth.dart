import 'package:firebase_auth/firebase_auth.dart';

/// FirebaseAuthProvider handles firebase authentication
class FirebaseAuthProvider {

  static final firebaseAuth = FirebaseAuth.instance;

  // getCurrentUser returns current firebase user
  static User? getCurrentUser() => firebaseAuth.currentUser;

  // loginWithToken helps in login with server token
  static Future<void> loginWithToken(String token) async {
    await firebaseAuth.signInWithCustomToken(token);
  }

  static Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

}