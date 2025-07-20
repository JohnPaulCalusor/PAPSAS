import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String membershipType,
    required String region,
  }) async {
    try {
      // Validate email format and region
      String domain = email.split('@')[1].toLowerCase();
      String username = email.split('@')[0].toLowerCase();
      String expectedRegion = 'region${region.split(' ').last.toLowerCase()}';
      if (domain != 'gmail.com') {
        throw Exception('Please use a Gmail address (e.g., yourname+region1@gmail.com)');
      }
      if (!username.endsWith(expectedRegion)) {
        throw Exception('Email username must end with $expectedRegion (e.g., yourname+$expectedRegion@gmail.com)');
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'membershipType': membershipType,
          'region': region,
          'registrationDate': Timestamp.now(),
          'email': email,
          'bio': '',
        });
      }
    } catch (e) {
      throw Exception('Sign-up failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateEmail(String newEmail, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Email update failed: ${e.message}');
    }
  }
}