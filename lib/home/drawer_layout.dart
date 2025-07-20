import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class DrawerLayout extends StatelessWidget {
  const DrawerLayout({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return snapshot.data() as Map<String, dynamic>?;
  }

  Future<bool> _hasVoted() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('votes')
        .where('userId', isEqualTo: user.uid)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final drawerWidth =
        isMobile ? (MediaQuery.of(context).size.width * 0.7).clamp(0, 250).toDouble() : null;
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      width: drawerWidth,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFFD32F2F)),
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFFD32F2F)),
                  child: Center(
                    child: Text(
                      'Error loading profile',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                );
              }

              var data = snapshot.data!;
              String fullName = data['fullName'] ?? 'Unknown';
              String email = data['email'] ?? '';
              String avatarPath = data['avatar'] ?? 'assets/images/avatar1.jpg';

              return DrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFD32F2F)),
                child: Row(
                  children: [
                    Hero(
                      tag: 'profile_avatar',
                      child: Container(
                        width: 60, // Adjusted to fit drawer layout
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28, // Adjusted to fit within container
                          backgroundColor: Colors.grey.shade100,
                          child: ClipOval(
                            child: Image.asset(
                              avatarPath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD32F2F),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 👇 Drawer body with white background
          Container(
            color: Colors.transparent,
            child: Column(
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  label: 'Home',
                  route: '/home',
                  currentRoute: currentRoute,
                ),
                const SizedBox(height: 16),
                _buildDrawerItem(
                  context,
                  icon: Icons.group,
                  label: 'Members',
                  route: '/members',
                  currentRoute: currentRoute,
                ),
                const SizedBox(height: 16),
                _buildDrawerItem(
                  context,
                  icon: Icons.how_to_vote,
                  label: 'Voting',
                  route: '/voting',
                  currentRoute: currentRoute,
                ),
                const SizedBox(height: 16),
                FutureBuilder<bool>(
                  future: _hasVoted(),
                  builder: (context, snapshot) {
                    bool enabled = snapshot.hasData && snapshot.data == true;
                    return ListTile(
                      leading: const Icon(Icons.bar_chart, color: Colors.red),
                      title: Text(
                        'Results',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: currentRoute == '/results'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: currentRoute == '/results',
                      selectedTileColor: Colors.red.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabled: enabled,
                      onTap: enabled
                          ? () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/results');
                            }
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildDrawerItem(
                  context,
                  icon: Icons.person,
                  label: 'Profile',
                  route: '/profile',
                  currentRoute: currentRoute,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: currentRoute == '/login'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: currentRoute == '/login',
                  selectedTileColor: Colors.red.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () async {
                    await AuthService().signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required String? currentRoute,
  }) {
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.red.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        if (!isSelected) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }
}