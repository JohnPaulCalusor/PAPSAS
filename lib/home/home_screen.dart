import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_application_1/home/drawer_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _videoController1;
  late VideoPlayerController _videoController2;

  @override
  void initState() {
    super.initState();
    _videoController1 = VideoPlayerController.networkUrl(Uri.parse('https://papsasinc.com/media/papsas_app/videos/avp_16iyf.mp4'))
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video 1: $error');
      });
    _videoController2 = VideoPlayerController.networkUrl(Uri.parse('https://papsasinc.com/media/papsas_app/videos/papsas_palawan.mp4'))
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video 2: $error');
      });
  }

  @override
  void dispose() {
    _videoController1.dispose();
    _videoController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
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
      body: user == null
          ? const Center(child: Text('Not logged in'))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Error loading user data'));
                }
                var data = snapshot.data!.data() as Map<String, dynamic>;
                String fullName = data['fullName'] ?? 'User';
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Welcome Section
                      Container(
                        width: double.infinity,
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome, $fullName!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 18 : 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'WELCOME TO THE PHILIPPINES ASSOCIATION OF PRACTITIONERS OF STUDENT AFFAIRS AND SERVICES, INC.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 18 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            _buildImageCarousel(context),
                            const SizedBox(height: 20),
                            Text(
                              'The Philippine Association of Practitioners of Student Affairs and Services, Inc. is the professional organization of student affairs and services administrators and practitioners in the Philippines, dedicated to the pursuit of excellence in student affairs and services work. It is an effective channel through which student affairs practitioners can develop and enhance their capabilities.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 14 : 16,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'PAPSAS, Inc. is committed to the formation of the Filipino educators through the conduct of effective and relevant programs and services addressing student issues and student affairs development. PAPSAS, Inc. is dedicated in building the competencies of its members through programs and services it offers.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 14 : 16,
                                color: Colors.black87,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      // Highlights Section
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFD32F2F),
                              Color(0xFF8B0000),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "PAPSAS'S HIGHLIGHTS",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: isMobile ? 22 : 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            StatefulBuilder(
                              builder: (context, setVideoState) {
                                bool isPlaying1 = false;
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 32),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildVideoPlayer(_videoController1, isPlaying1, (value) {
                                        setVideoState(() {
                                          isPlaying1 = value;
                                        });
                                      }, isMobile),
                                      const SizedBox(height: 16),
                                      _buildVideoDescription(
                                        '𝟭𝟲𝘁𝗵 𝗜𝗡𝗧𝗘𝗥𝗔𝗖𝗧𝗜𝗩𝗘 𝗬𝗢𝗨𝗧𝗛 𝗙𝗢𝗥𝗨𝗠',
                                        '𝐑𝐞𝐥𝐢𝐯𝐞 𝐭𝐡𝐞 𝐦𝐨𝐦𝐞𝐧𝐭𝐬 𝐨𝐟 𝐢𝐧𝐬𝐩𝐢𝐫𝐚𝐭𝐢𝐨𝐧 𝐚𝐧𝐝 𝐜𝐨𝐥𝐥𝐚𝐛𝐨𝐫𝐚𝐭𝐢𝐨𝐧 𝐟𝐫𝐨𝐦 𝐭𝐡𝐞 𝟏𝟔𝐭𝐡 𝐈𝐧𝐭𝐞𝐫𝐚𝐜𝐭𝗶𝐯𝐞 𝐘𝐨𝐮𝐭𝗵 𝐅𝐨𝐫𝗺! Watch our highlight video capturing the essence of #Volunteerism: Passion, Compassion, and Action held from February 5-7, 2025 at Venus Parkview Hotel, Baguio City.',
                                        'From insightful discussion to impactful initiatives, witness how youth leaders from across the country came together to create a positive change.',
                                        'Together, let\'s continue to advocate for a brighter future through passion-driven volunteerism. Until next time, student leaders and volunteers!',
                                        isMobile,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            StatefulBuilder(
                              builder: (context, setVideoState) {
                                bool isPlaying2 = false;
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildVideoPlayer(_videoController2, isPlaying2, (value) {
                                        setVideoState(() {
                                          isPlaying2 = value;
                                        });
                                      }, isMobile),
                                      const SizedBox(height: 16),
                                      _buildVideoDescription(
                                        '🎬 HIGHLIGHTS REEL: 29th PAPSAS National Conference and Training Workshop 🎬',
                                        'Relive the inspiring moments of the 29th PAPSAS National Conference and Training Workshop held last April 10-12, 2025 at Costa Palawan Resort, Puerto Princesa City! 🏝️',
                                        'With the theme "Weaving an Integrated SAS Approach toward a Healthy Learning Environment," the conference brought together student affairs and services practitioners and student organization moderators/advisers from across the country to collaborate, learn, and build a healthier educational community.',
                                        'Thank you to everyone who made this event a success!',
                                        isMobile,
                                      ),
                                    ],
                                  ),
                                );
                              },
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
  }

  Widget _buildImageCarousel(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 16.0, vertical: 12.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: isMobile ? 160 : 220,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: isMobile ? 0.85 : 0.35,
          enableInfiniteScroll: true,
          scrollPhysics: const BouncingScrollPhysics(),
        ),
        items: [
          _buildCarouselItem('Conference Image 1', 'assets/images/conference_1.jpg'),
          _buildCarouselItem('Conference Image 2', 'assets/images/conference_2.jpg'),
          _buildCarouselItem('Conference Image 3', 'assets/images/conference_3.jpg'),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String title, String imagePath) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.image_not_supported,
                size: 40,
                color: Color.fromARGB(255, 118, 117, 117),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerController controller, bool isPlaying, Function(bool) onPlayPause, bool isMobile) {
    if (!controller.value.isInitialized) {
      return Container(
        width: double.infinity,
        height: isMobile ? 220 : 320,
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return GestureDetector(
      onTap: () {
        print('Tapped video player, isPlaying: $isPlaying, controller.isPlaying: ${controller.value.isPlaying}');
        if (controller.value.isPlaying) {
          controller.pause();
          onPlayPause(false);
        } else {
          controller.play();
          onPlayPause(true);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: isMobile ? double.infinity : 600,
            height: isMobile ? 220 : 320,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: VideoPlayer(controller),
              ),
            ),
          ),
          if (!controller.value.isPlaying) // Use controller state to hide/show center play button
            const Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 90,
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow, // Use controller state for bottom button
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      if (controller.value.isPlaying) {
                        controller.pause();
                        onPlayPause(false);
                      } else {
                        controller.play();
                        onPlayPause(true);
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: controller.value.position.inSeconds / controller.value.duration.inSeconds,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${controller.value.position.inMinutes}:${(controller.value.position.inSeconds % 60).toString().padLeft(2, '0')} / '
                    '${controller.value.duration.inMinutes}:${(controller.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoDescription(String title, String subtitle, String description, String thanks, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 14 : 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 14 : 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 12),
          Text(
            thanks,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isMobile ? 14 : 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}