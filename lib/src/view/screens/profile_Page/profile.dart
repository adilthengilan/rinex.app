import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


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

  
  final List<String> listingImages = [
    'assets/property4.jpg',
    'assets/property2.jpg',
 '   assets/apartment1.jpg',
  'assets/property4.jpg',
     'assets/property2.jpg',
      'assets/apartment1.jpg'
  ];

  final List<String> clipsImages = [
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
    // Navigate to messages page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening messages...')),
    );
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Name Example',
                style: TextStyle(
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
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _handleMessageClick,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture and stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
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
              
              // Stats
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
          
          // Username
          Text(
            'RNX-11220FR',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action Buttons
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
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              images[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: Icon(Icons.image, color: Colors.grey.shade400),
                );
              },
            ),
            if (activeTab == 'listing' && index > 1 || activeTab == 'clips')
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
      },
    );
  }
}