import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/common/models.dart';
import 'package:flutter_application_1/common/validators.dart';

Future<void> seedSampleVotes() async {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final regions = List.generate(18, (index) => 'Region ${index + 1}');
  final membershipTypes = ['Regular', 'Special', 'Affiliate', 'Lifetime'];

  try {
    // 1) Check if we have at least 18 users
    final initialSnapshot = await firestore.collection('users').get();
    if (initialSnapshot.docs.length < 18) {
      // Seed one user per region (18 users)
      for (int i = 1; i <= 18; i++) {
        final region = 'Region $i';
        final email = 'laststephenzoleta+region$i@gmail.com';
        final membershipType = membershipTypes[i % membershipTypes.length];
        final fullName = 'User Region $i';

        if (!isValidDomain(email, region)) {
          print('Invalid email for region $i: $email');
          continue;
        }

        // Skip if email already exists in Auth
        final methods = await auth.fetchSignInMethodsForEmail(email);
        if (methods.isNotEmpty) {
          print('Email $email already exists, skipping creation');
          continue;
        }

        try {
          final uc = await auth.createUserWithEmailAndPassword(
            email: email,
            password: 'password123',
          );
          final user = uc.user;
          if (user != null) {
            // No email verification for demo accounts
            await firestore.collection('users').doc(user.uid).set({
              'fullName': fullName,
              'email': email,
              'region': region,
              'membershipType': membershipType,
              'registrationDate': Timestamp.now(),
              'bio': '',
            });
            print('Created user $email');
          }
        } catch (e) {
          print('Error creating user $email: $e');
        }
      }
    } else {
      print('Already have ${initialSnapshot.docs.length} users, skipping user seeding');
    }

    // 2) Seed 150 votes
    final allUsersSnapshot = await firestore.collection('users').get();
    final userIds = allUsersSnapshot.docs.map((doc) => doc.id).toList();
    if (userIds.isEmpty) {
      print('No users found; cannot seed votes');
      return;
    }

    for (int i = 0; i < 150; i++) {
      final userId = userIds[i % userIds.length];
      final userDoc = allUsersSnapshot.docs.firstWhere((d) => d.id == userId);
      final region = userDoc['region'] as String;
      final candidate = candidates[i % candidates.length];

      await firestore.collection('votes').add({
        'userId': userId,
        'candidateId': candidate.id,
        'region': region,
        'timestamp': Timestamp.now(),
      });
    }

    print('Sample users and votes seeded successfully');
  } catch (e) {
    print('Error seeding sample votes: $e');
  }
}
