import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/common/models.dart';
import 'package:flutter_application_1/home/drawer_layout.dart';
import 'package:flutter_application_1/voting/voting_provider.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class VotingScreen extends StatelessWidget {
  const VotingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/papsas_logo.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PAPSAS INC.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const DrawerLayout(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Color(0xFF8B0000)],
          ),
        ),
        child: user == null
            ? const Center(child: Text('Not logged in', style: TextStyle(color: Colors.white)))
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text('Error loading user data', style: TextStyle(color: Colors.white)));
                  }
                  final region = (snapshot.data!.data() as Map<String, dynamic>)['region'];
                  print('Voting with region: $region'); // Debug log
                  return ChangeNotifierProvider(
                    create: (context) => VotingProvider()..checkConnectivity(),
                    child: Consumer<VotingProvider>(
                      builder: (context, provider, child) {
                        final isMobile = MediaQuery.of(context).size.width < 600;
                        final groupedCandidates = <String, List<Candidate>>{};
                        for (var candidate in candidates) {
                          groupedCandidates.putIfAbsent(candidate.description, () => []).add(candidate);
                        }
                        return Padding(
                          padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Voting Page',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (provider.error.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: provider.error.contains('Thank you') ? Colors.green[100] : Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    provider.error,
                                    style: TextStyle(
                                      color: provider.error.contains('Thank you') ? Colors.green[800] : Colors.red[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              else if (!provider.isConnected)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'No internet connection',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                              Expanded(
                                child: ListView(
                                  children: groupedCandidates.entries.map((entry) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          child: Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: isMobile ? 18 : 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: isMobile ? 8.0 : 16.0,
                                          runSpacing: isMobile ? 8.0 : 16.0,
                                          children: entry.value.map((candidate) => GestureDetector(
                                            onTap: () => provider.setSelectedCandidate(entry.key, candidate),
                                            child: AnimatedScale(
                                              scale: provider.selectedCandidates[entry.key] == candidate ? 1.05 : 1.0,
                                              duration: const Duration(milliseconds: 200),
                                              child: SizedBox(
                                                width: 250,
                                                child: Card(
                                                  elevation: provider.selectedCandidates[entry.key] == candidate ? 4 : 2,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                  margin: EdgeInsets.zero,
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
                                                    leading: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.asset(
                                                        candidate.imageAsset,
                                                        width: isMobile ? 50 : 60,
                                                        height: isMobile ? 50 : 60,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          print('Image load error for ${candidate.imageAsset}: $error, StackTrace: $stackTrace');
                                                          return Icon(
                                                            Icons.person,
                                                            size: isMobile ? 50 : 60,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    title: Text(
                                                      '${candidate.name}, ${candidate.age}',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: isMobile ? 14 : 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      candidate.description,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: isMobile ? 10 : 14,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )).toList(),
                                        ),
                                        SizedBox(height: isMobile ? 16.0 : 32.0),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    if (!provider.areAllPositionsSelected)
                                      Text(
                                        'Please select one ${VotingProvider.requiredPositions.firstWhere((pos) => provider.selectedCandidates[pos] == null)}',
                                        style: TextStyle(color: Colors.white, fontSize: isMobile ? 12 : 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ElevatedButton(
                                      onPressed: provider.isConnected && provider.areAllPositionsSelected
                                          ? () async {
                                              bool confirm = await showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Confirm Votes'),
                                                  content: const Text('Are you sure you want to vote for the selected candidates?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, false),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context, true),
                                                      child: const Text('Confirm'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm ?? false) {
                                                await provider.castVotes(region);
                                                if (provider.error == 'Thank you for voting!') {
                                                  await Future.delayed(const Duration(seconds: 2));
                                                  Navigator.pushNamed(context, '/results');
                                                }
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(130, 50),
                                        backgroundColor: provider.isConnected && provider.areAllPositionsSelected ? Colors.white : Colors.grey,
                                      ),
                                      child: const Text(
                                        'Vote',
                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}