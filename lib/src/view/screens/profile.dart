import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;

  // List of image paths as assets
  // MAKE SURE THESE PATHS MATCH THE ONES IN YOUR pubspec.yaml AND PROJECT STRUCTURE
  final List<String> _imageAssetPaths = [
    'lib/assets/building.jpg', // Assuming you have a profile image
    'lib/assets/property4.jpg',
    'lib/assets/property2.jpg',
    'assets/images/building.jpg',
    // You can add more image paths here to fill the grid, or repeat existing ones
    'lib/assets/building.jpg', // Assuming you have a profile image
    'lib/assets/property4.jpg',
    'lib/assets/property2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // TODO: Implement back button functionality
            print('Back button pressed');
          },
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name Example', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Icon(Icons.check_circle, color: Colors.blue, size: 18), // Verified badge
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.black),
            onPressed: () {
              // TODO: Implement send message functionality
              print('Send message button pressed');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Picture - using a placeholder for now, you can change this
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 50, color: Colors.white), // Placeholder if no image
                        // If you have a specific profile picture asset:
                        // backgroundImage: AssetImage('assets/images/profile_pic.jpg'),
                      ),
                      const SizedBox(width: 20),
                      _buildStatColumn('post', '2'),
                      const SizedBox(width: 20),
                      _buildStatColumn('followers', '322'),
                      const SizedBox(width: 20),
                      _buildStatColumn('following', '27'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RNX-11220FR',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isFollowing = !_isFollowing;
                            });
                            print('Follow button pressed, now: $_isFollowing');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            _isFollowing ? 'Following' : 'Follow',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement message button functionality
                            print('Message button pressed');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Message',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabIcon(Icons.business, true, () {
                    // TODO: Implement Listing tab functionality
                    print('Listing tab pressed');
                  }),
                  _buildTabIcon(Icons.videocam, false, () {
                    // TODO: Implement Clips tab functionality
                    print('Clips tab pressed');
                  }),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _imageAssetPaths.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 1.0, // For square images
              ),
              itemBuilder: (context, index) {
                return Image.asset( // Changed to Image.asset
                  _imageAssetPaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  // You might want to add error handling for assets if the path is wrong
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, color: Colors.red));
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // TODO: Implement home button functionality
                print('Home button pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.business),
              onPressed: () {
                // TODO: Implement business button functionality
                print('Business button pressed');
              },
            ),
            const SizedBox(width: 48), // Spacer for the FAB
            IconButton(
              icon: const Icon(Icons.play_circle_fill),
              onPressed: () {
                // TODO: Implement play button functionality
                print('Play button pressed');
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // TODO: Implement person button functionality
                print('Person button pressed');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add button functionality
          print('Add button pressed');
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTabIcon(IconData icon, bool isActive, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: isActive
            ? const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blue, width: 2.0),
                ),
              )
            : null,
        child: Icon(
          icon,
          color: isActive ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}