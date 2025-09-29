
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rinex/src/view/screens/agentlist.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool isFollowing = false;
  final TextEditingController _messageController = TextEditingController();

  // User profile data
  final Map<String, dynamic> userProfile = {
    'name': 'Name Example',
    'username': 'RNX-11220FR',
    'isVerified': true,
    'postsCount': 2,
    'followersCount': 322,
    'followingCount': 27,
    'profileImageUrl': null, // Using default icon
  };

  final List<PropertyItem> listings = [
    PropertyItem(
      id: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=300&fit=crop',
      isVideo: false,
      type: 'House',
      title: 'Modern Luxury Villa',
      location: 'Beverly Hills, CA',
      price: 2500000,
      bedrooms: 5,
      bathrooms: 4,
      area: 4500,
      description:
          'Stunning modern villa with panoramic city views, featuring open-plan living spaces, premium finishes, and a resort-style backyard.',
    ),
    PropertyItem(
      id: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=400&h=300&fit=crop',
      isVideo: false,
      type: 'Interior',
      title: 'Luxury Interior Design',
      location: 'Los Angeles, CA',
      price: 1800000,
      bedrooms: 3,
      bathrooms: 3,
      area: 3200,
      description:
          'Exquisitely designed interior spaces with premium materials and contemporary furnishings throughout.',
    ),
    PropertyItem(
      id: 3,
      imageUrl:
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Building',
      title: 'Modern Architecture',
      location: 'Downtown LA, CA',
      price: 3200000,
      bedrooms: 4,
      bathrooms: 4,
      area: 3800,
      description:
          'Architectural masterpiece in the heart of downtown with floor-to-ceiling windows and premium amenities.',
    ),
    PropertyItem(
      id: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Building',
      title: 'City Skyline View',
      location: 'West Hollywood, CA',
      price: 950000,
      bedrooms: 2,
      bathrooms: 2,
      area: 1850,
      description:
          'Breathtaking city views from every room in this sophisticated urban residence.',
    ),
    PropertyItem(
      id: 5,
      imageUrl:
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=400&h=400&fit=crop',
      isVideo: false,
      type: 'Building',
      title: 'Glass Tower',
      location: 'Century City, CA',
      price: 5800000,
      bedrooms: 6,
      bathrooms: 5,
      area: 6200,
      description:
          'Luxury penthouse in prestigious glass tower with world-class amenities and concierge services.',
    ),
    PropertyItem(
      id: 6,
      imageUrl:
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=400&fit=crop',
      isVideo: false,
      type: 'House',
      title: 'Lakeside Retreat',
      location: 'Malibu, CA',
      price: 1200000,
      bedrooms: 3,
      bathrooms: 2,
      area: 2800,
      description:
          'Serene lakeside property perfect for weekend getaways with private dock and mountain views.',
    ),
    PropertyItem(
      id: 7,
      imageUrl:
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=400&h=400&fit=crop',
      isVideo: false,
      type: 'House',
      title: 'Historic Mansion',
      location: 'Pasadena, CA',
      price: 1750000,
      bedrooms: 4,
      bathrooms: 3,
      area: 4200,
      description:
          'Beautifully restored historic mansion with original architectural details and modern updates.',
    ),
    PropertyItem(
      id: 8,
      imageUrl:
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Interior',
      title: 'Luxury Bathroom',
      location: 'Beverly Hills, CA',
      price: 1100000,
      bedrooms: 2,
      bathrooms: 3,
      area: 2200,
      description:
          'Spa-like luxury bathroom with premium fixtures and finishes throughout the residence.',
    ),
    PropertyItem(
      id: 9,
      imageUrl:
          'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=400&h=400&fit=crop',
      isVideo: false,
      type: 'Building',
      title: 'Modern Towers',
      location: 'Santa Monica, CA',
      price: 2100000,
      bedrooms: 3,
      bathrooms: 3,
      area: 3100,
      description:
          'Contemporary living in Santa Monica with ocean proximity and luxury amenities.',
    ),
  ];

  final List<PropertyItem> clips = [
    PropertyItem(
      id: 10,
      imageUrl:
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Building',
      title: 'Architecture Tour',
      location: 'Downtown LA, CA',
      price: 0,
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      description:
          'Virtual tour showcasing innovative architectural design and construction techniques.',
    ),
    PropertyItem(
      id: 11,
      imageUrl:
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Building',
      title: 'Property Walkthrough',
      location: 'West Hollywood, CA',
      price: 0,
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      description:
          'Complete property walkthrough highlighting key features and amenities.',
    ),
    PropertyItem(
      id: 12,
      imageUrl:
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Interior',
      title: 'Interior Design Tips',
      location: 'Beverly Hills, CA',
      price: 0,
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      description:
          'Professional interior design tips and trends for luxury living spaces.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    HapticFeedback.lightImpact();
    // Navigate back to home screen
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.home, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Navigating to Home'),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
      if (isFollowing) {
        userProfile['followersCount']++;
      } else {
        userProfile['followersCount']--;
      }
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isFollowing ? Icons.person_add : Icons.person_remove,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              isFollowing
                  ? 'Following ${userProfile['name']}'
                  : 'Unfollowed ${userProfile['name']}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
        backgroundColor: isFollowing ? Colors.green : Colors.grey[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _sendMessage() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.message, color: Colors.blue),
                SizedBox(width: 8),
                Text('Send Message'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Send a message to ${userProfile['name']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    prefixIcon: Icon(Icons.edit, color: Colors.blue),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _messageController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    Navigator.pop(context);
                    _messageController.clear();
                    HapticFeedback.mediumImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Message sent to ${userProfile['name']}'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.send),
                label: Text('Send'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _shareProfile() {
    HapticFeedback.lightImpact();
    // Simulate copying to clipboard
    Clipboard.setData(
      ClipboardData(
        text: 'https://realestate.app/profile/${userProfile['username']}',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.link, color: Colors.white),
            SizedBox(width: 8),
            Text('Profile link copied to clipboard'),
          ],
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showUserStats() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        '${userProfile['name']} Statistics',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildDetailedStatRow(
                        'Total Posts',
                        '${userProfile['postsCount']}',
                        Icons.grid_on,
                      ),
                      _buildDetailedStatRow(
                        'Followers',
                        '${userProfile['followersCount']}',
                        Icons.people,
                      ),
                      _buildDetailedStatRow(
                        'Following',
                        '${userProfile['followingCount']}',
                        Icons.person_add,
                      ),
                      _buildDetailedStatRow(
                        'Properties Listed',
                        '${listings.length}',
                        Icons.home,
                      ),
                      _buildDetailedStatRow(
                        'Video Content',
                        '${clips.length}',
                        Icons.play_circle_outline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailedStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Top App Bar with Back Arrow
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _shareProfile,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.send, color: Colors.blue, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Name and Verified Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userProfile['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (userProfile['isVerified'])
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Profile Info Row
                    Row(
                      children: [
                        // Profile Picture
                        GestureDetector(
                          onTap: () {
                            // Show profile picture in full screen
                            _showProfilePicture();
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                        SizedBox(width: 30),

                        // Stats
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: _showUserStats,
                                child: _buildStatColumn(
                                  '${userProfile['postsCount']}',
                                  'post',
                                ),
                              ),
                              GestureDetector(
                                onTap: _showUserStats,
                                child: _buildStatColumn(
                                  '${userProfile['followersCount']}',
                                  'followers',
                                ),
                              ),
                              GestureDetector(
                                onTap: _showUserStats,
                                child: _buildStatColumn(
                                  '${userProfile['followingCount']}',
                                  'following',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    // Bio
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userProfile['username'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: _toggleFollow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isFollowing
                                        ? Colors.grey[300]
                                        : Colors.blue,
                                foregroundColor:
                                    isFollowing ? Colors.black87 : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                elevation: isFollowing ? 0 : 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isFollowing
                                        ? Icons.person_remove
                                        : Icons.person_add,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    isFollowing ? 'Following' : 'Follow',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.message, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  'Message',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: Colors.blue,
                  indicatorWeight: 3,
                  onTap: (index) {
                    HapticFeedback.selectionClick();
                  },
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.business, size: 18),
                          SizedBox(width: 8),
                          Text('Listing', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_outline, size: 18),
                          SizedBox(width: 8),
                          Text('Clips', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Listings Tab
                    _buildPropertyGrid(listings),
                    // Clips Tab
                    _buildPropertyGrid(clips),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPropertyGrid(List<PropertyItem> properties) {
    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No properties available',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Properties will appear here once added',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(2),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return PropertyGridItem(
          property: properties[index],
          onTap: () => _viewProperty(properties[index]),
        );
      },
    );
  }

  void _viewProperty(PropertyItem property) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => PropertyDetailsSheet(
            property: property,
            onContact: _sendMessage,
            onShare: _shareProfile,
          ),
    );
  }

  void _showProfilePicture() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Icon(Icons.person, size: 100, color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                Text(
                  userProfile['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class PropertyGridItem extends StatelessWidget {
  final PropertyItem property;
  final VoidCallback onTap;

  const PropertyGridItem({
    Key? key,
    required this.property,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                property.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                      size: 30,
                    ),
                  );
                },
              ),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),

            // Video Play Button
            if (property.isVideo)
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.blue, size: 20),
                ),
              ),

            // Price overlay for listings
            if (property.price > 0)
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    property.formattedPrice,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PropertyDetailsSheet extends StatefulWidget {
  final PropertyItem property;
  final VoidCallback onContact;
  final VoidCallback onShare;

  const PropertyDetailsSheet({
    Key? key,
    required this.property,
    required this.onContact,
    required this.onShare,
  }) : super(key: key);

  @override
  _PropertyDetailsSheetState createState() => _PropertyDetailsSheetState();
}

class _PropertyDetailsSheetState extends State<PropertyDetailsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 400),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          height: 250,
                          width: double.infinity,
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  widget.property.imageUrl,
                                  fit: BoxFit.cover,
                                ),

                                // Top overlay with favorite and type
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  right: 12,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          widget.property.type,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _toggleFavorite,
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                isFavorite
                                                    ? Colors.red
                                                    : Colors.grey[600],
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Video play button
                                if (widget.property.isVideo)
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 8,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.blue,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Property details
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.property.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.property.location,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (widget.property.price > 0) ...[
                                SizedBox(height: 12),
                                Text(
                                  widget.property.formattedPrice,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],

                              // Property specifications
                              if (widget.property.bedrooms > 0) ...[
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    _buildSpecItem(
                                      Icons.bed,
                                      '${widget.property.bedrooms} Beds',
                                    ),
                                    SizedBox(width: 20),
                                    _buildSpecItem(
                                      Icons.bathtub,
                                      '${widget.property.bathrooms} Baths',
                                    ),
                                    SizedBox(width: 20),
                                    _buildSpecItem(
                                      Icons.square_foot,
                                      '${widget.property.area} sqft',
                                    ),
                                  ],
                                ),
                              ],

                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300]),
                              SizedBox(height: 16),

                              // Description
                              Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.property.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),

                              SizedBox(height: 24),

                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Agentscreen(),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.message),
                                      label: Text('Contact Agent'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: widget.onShare,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      foregroundColor: Colors.grey[700],
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Icon(Icons.share),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PropertyItem {
  final int id;
  final String imageUrl;
  final bool isVideo;
  final String type;
  final String title;
  final String location;
  final int price;
  final int bedrooms;
  final int bathrooms;
  final int area;
  final String description;

  PropertyItem({
    required this.id,
    required this.imageUrl,
    required this.isVideo,
    required this.type,
    required this.title,
    required this.location,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.description,
  });

  String get formattedPrice {
    if (price >= 1000000) {
      return '\${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\${(price / 1000).toStringAsFixed(0)}K';
    } else if (price > 0) {
      return '\$price';
    } else {
      return 'Free Content';
    }
  }
}
