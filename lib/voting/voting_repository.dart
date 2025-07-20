import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VotingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> hasVoted(String userId) async {
    try {
      final snapshot = await _firestore.collection('votes').where('userId', isEqualTo: userId).get();
      print('hasVoted query result for $userId: ${snapshot.docs.length} documents'); // Debug log
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking vote status for $userId: $e');
      return false; // Allow voting if query fails (e.g., quota exceeded)
    }
  }

  Future<void> castVote(String candidateId, String region) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    await _firestore.collection('votes').add({
      'userId': user.uid,
      'candidateId': candidateId,
      'region': region,
      'timestamp': Timestamp.now(),
    });
  }
}