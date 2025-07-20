import 'package:cloud_firestore/cloud_firestore.dart';

/// --- Member Model with Firestore mapping ---
class Member {
  final String name;
  final String email;
  final String membershipType;
  final String role;
  final String imageAsset;
  final DateTime registrationDate; // convert Timestamp → DateTime

  Member({
    required this.name,
    required this.email,
    required this.membershipType,
    required this.role,
    required this.imageAsset,
    required this.registrationDate,
  });

  /// Create a Member from a Firestore document
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['name'] as String,
      email: map['email'] as String,
      membershipType: map['membershipType'] as String,
      role: map['role'] as String,
      imageAsset: map['imageAsset'] as String,
      registrationDate: (map['registrationDate'] as Timestamp).toDate(),
    );
  }

  /// Convert Member to a map for Firestore writes
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'membershipType': membershipType,
      'role': role,
      'imageAsset': imageAsset,
      'registrationDate': Timestamp.fromDate(registrationDate),
    };
  }
}

/// --- Candidate Model (hard‑coded list below) ---
class Candidate {
  final String id;
  final String name;
  final int age;
  final String description;
  final String imageAsset;

  Candidate(this.id, this.name, this.age, this.description, this.imageAsset);
}

final candidates = <Candidate>[
  Candidate('c1', 'Dr. Alice B. Carter', 26, 'Director', 'assets/images/alice_carter.jpg'),
  Candidate('c2', 'Mr. David F. Evans', 27, 'Director', 'assets/images/david_evans.jpg'),
  Candidate('c3', 'Dr. Maria J. Flores', 28, 'Adviser', 'assets/images/maria_flores.jpg'),
  Candidate('c4', 'Mr. Thomas K. Grant', 38, 'Adviser', 'assets/images/thomas_grant.jpg'),
  Candidate('c5', 'Mr. Oliver M. Hayes', 50, 'Adviser', 'assets/images/oliver_hayes.jpg'),
];

/// --- Vote Model with Firestore mapping ---
class Vote {
  final String userId;
  final String candidateId;
  final String region;
  final DateTime timestamp; // convert Timestamp → DateTime

  Vote({
    required this.userId,
    required this.candidateId,
    required this.region,
    required this.timestamp,
  });

  /// Create a Vote from a Firestore document
  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      userId: map['userId'] as String,
      candidateId: map['candidateId'] as String,
      region: map['region'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Convert Vote to a map for Firestore writes
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'candidateId': candidateId,
      'region': region,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
