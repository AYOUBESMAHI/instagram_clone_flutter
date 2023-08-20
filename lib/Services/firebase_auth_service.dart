import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _firebase = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebase;
  Future<String> createUserFirebase(String email, String password) async {
    try {
      await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      return _firebase.currentUser!.uid;
    } on FirebaseAuthException catch (err) {
      throw err.message!;
    }
  }

  Future<String> signInUserFirebase(String email, String password) async {
    try {
      await _firebase.signInWithEmailAndPassword(
          email: email, password: password);
      return _firebase.currentUser!.uid;
    } on FirebaseAuthException catch (err) {
      throw err.message!;
    }
  }

  Future<void> signOutFirebase() async {
    try {
      await _firebase.signOut();
    } on FirebaseAuthException catch (err) {
      throw err.message!;
    }
  }
}
