import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/models.dart';
import 'package:flutter_application_1/members/members_repository.dart';
import 'package:flutter_application_1/home/drawer_layout.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MembersRepository();
    final isMobile = MediaQuery.of(context).size.width < 600;

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
                color: Colors.red,
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
        child: StreamBuilder<List<Member>>(
          stream: repository.getMembers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text('Error loading members: ${snapshot.error}'));
            }
            final members = snapshot.data!;
            final groupedMembers = <String, List<Member>>{};
            for (var member in members) {
              groupedMembers.putIfAbsent(member.role, () => []).add(member);
            }
            return ListView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              children: groupedMembers.entries.map((entry) {
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
                          color: Colors.white, // Changed from Colors.red to Colors.white
                        ),
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: isMobile ? 8.0 : 16.0,
                      runSpacing: isMobile ? 8.0 : 16.0,
                      children: entry.value.map((member) => SizedBox(
                        width: 250,
                        height: 360,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          margin: EdgeInsets.zero,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      member.imageAsset,
                                      width: 220,
                                      height: 220,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Image load error for ${member.imageAsset}: $error');
                                        return const Icon(Icons.person, size: 220);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member.name,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: isMobile ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member.email,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: isMobile ? 11.5 : 13.5,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Membership: ${member.membershipType}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: isMobile ? 11.5 : 13.5,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
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
            );
          },
        ),
      ),
    );
  }
}