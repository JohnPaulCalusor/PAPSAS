import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedSampleMembers() async {
  final membersCollection = FirebaseFirestore.instance.collection('members');
  final snapshot = await membersCollection.get();
  if (snapshot.docs.isEmpty) {
    final sampleMembers = [
      {
        'name': 'Dr. Adelaida C. Fronda',
        'email': 'adelaida@region1.com',
        'membershipType': 'Lifetime',
        'role': 'Adviser',
        'imageAsset': 'assets/images/adelaida_fronda.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Dr. Evelyn A. Songco',
        'email': 'evelyn@region2.com',
        'membershipType': 'Lifetime',
        'role': 'Adviser',
        'imageAsset': 'assets/images/evelyn_songco.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Mr. Vincent M. Alcantara',
        'email': 'vincent@region3.com',
        'membershipType': 'Lifetime',
        'role': 'Director',
        'imageAsset': 'assets/images/vincent_alcantara.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Mr. Jefferson I. Cañada',
        'email': 'jefferson@region4.com',
        'membershipType': 'Lifetime',
        'role': 'Director',
        'imageAsset': 'assets/images/jefferson_canada.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Mr. Rodolfo SB. Virtus, Jr.',
        'email': 'rodolfo@region5.com',
        'membershipType': 'Lifetime',
        'role': 'Director',
        'imageAsset': 'assets/images/rodolfo_virtus.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Mr. Jun L. Tayaben',
        'email': 'jun@region6.com',
        'membershipType': 'Lifetime',
        'role': 'Executive Officer',
        'imageAsset': 'assets/images/jun_tayaben.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Dr. Edna Gladys T. Calingacion',
        'email': 'edna@region7.com',
        'membershipType': 'Lifetime',
        'role': 'Executive Officer',
        'imageAsset': 'assets/images/edna_calingacion.jpg',
        'registrationDate': Timestamp.now(),
      },
      {
        'name': 'Dr. Renelyn B. Salcedo',
        'email': 'renelyn@region8.com',
        'membershipType': 'Lifetime',
        'role': 'Executive Officer',
        'imageAsset': 'assets/images/renelyn_salcedo.jpg',
        'registrationDate': Timestamp.now(),
      },
    ];
    for (var member in sampleMembers) {
      await membersCollection.add(member);
    }
  }
}
