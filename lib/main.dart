import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login_screen.dart';
import 'package:flutter_application_1/auth/sign_up_screen.dart';
import 'package:flutter_application_1/home/home_screen.dart';
import 'package:flutter_application_1/members/members_screen.dart';
import 'package:flutter_application_1/members/seed_sample_members.dart';
import 'package:flutter_application_1/profile/profile_screen.dart';
import 'package:flutter_application_1/results/results_screen.dart';
import 'package:flutter_application_1/voting/voting_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await seedSampleMembers();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/members': (context) => const MembersScreen(),
        '/voting': (context) => const VotingScreen(),
        '/results': (context) => const ResultsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}


