import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/common/models.dart';

class MembersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Member>> getMembers() {
    return _firestore
        .collection('members')
        .orderBy('registrationDate') // optional: deterministic ordering
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            // cast to Map<String, dynamic> and use your factory
            final data = doc.data() as Map<String, dynamic>;
            return Member.fromMap(data);
          })
          .toList();
    });
  }
}