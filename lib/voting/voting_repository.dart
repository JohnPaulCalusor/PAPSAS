import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/models.dart';

class VotingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Candidate>> getCandidates() async {
    QuerySnapshot snapshot = await _firestore.collection('candidates').get();
    return snapshot.docs.map((doc) => Candidate.fromFirestore(doc)).toList();
  }

  Future<List<Vote>> getVotes() async {
    QuerySnapshot snapshot = await _firestore.collection('votes').get();
    return snapshot.docs.map((doc) => Vote.fromFirestore(doc)).toList();
  }

  Future<void> addVote(String voterEmail, String candidateId) async {
    await _firestore.collection('votes').add({
      'voterEmail': voterEmail,
      'candidateId': candidateId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}