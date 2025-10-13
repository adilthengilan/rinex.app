import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  String activeTab = 'listing';
  File? profileImage;
  final ImagePicker _picker = ImagePicker();
  final Random _random = Random();

  List<String> listingImages = [
    'assets/property4.jpg',
    'assets/property2.jpg',
    'assets/apartment1.jpg',
    'assets/property4.jpg',
    'assets/property2.jpg',
    'assets/apartment1.jpg'
  ];

  List<String> clipsImages = [
    'assets/property4.jpg',
    'assets/property2.jpg',
    'assets/apartment1.jpg',
    'assets/building.jpg',
  ];

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  void _handleFollowClick() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  void _handleMessageClick() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening messages...')),
    );
  }

  void _shuffleImages() {
    setState(() {
      if (activeTab == 'listing') {
        listingImages.shuffle(_random);
      } else {
        clipsImages.shuffle(_random);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Images shuffled!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  double _getImageHeight(int index) {
    List<double> ratios = [1.0, 1.3, 0.8, 1.2, 0.9, 1.1];
    double baseWidth = (MediaQuery.of(context).size.width - 4) / 3;
    return baseWidth * ratios[index % ratios.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(),
                  _buildTabs(),
                  _buildContentGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Name Example',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.verified,
            color: Colors.blue.shade500,
            size: 20,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shuffle, color: Colors.black87),
          onPressed: _shuffleImages,
          tooltip: 'Shuffle Images',
        ),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.black87),
          onPressed: _handleMessageClick,
          tooltip: 'Send Message',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade200,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            profileImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.grey.shade600,
                        ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('2', 'post'),
                    _buildStatColumn('322', 'followers'),
                    _buildStatColumn('27', 'following'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'RNX-11220FR',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleFollowClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing ? Colors.grey.shade200 : Colors.blue,
                    foregroundColor: isFollowing ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleMessageClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              icon: Icons.grid_on,
              label: 'Listing',
              isActive: activeTab == 'listing',
              onTap: () => setState(() => activeTab = 'listing'),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              icon: Icons.play_circle_outline,
              label: 'Clips',
              isActive: activeTab == 'clips',
              onTap: () => setState(() => activeTab = 'clips'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isActive ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.black : Colors.grey.shade400,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.black : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentGrid() {
    List<String> images = activeTab == 'listing' ? listingImages : clipsImages;
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 4) / 3;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(2),
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        children: List.generate(images.length, (index) {
          return SizedBox(
            width: itemWidth,
            height: _getImageHeight(index),
            child: _buildImageItem(images[index], index),
          );
        }),
      ),
    );
  }

  Widget _buildImageItem(String imagePath, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: Icon(Icons.image, color: Colors.grey.shade400),
            );
          },
        ),
        if ((activeTab == 'listing' && index > 1) || activeTab == 'clips')
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        if (activeTab == 'clips')
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              '${(index + 1) * 15}K views',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}