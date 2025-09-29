
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rinex/src/view/screens/agentlist.dart';

class Editprofile extends StatefulWidget {
  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> 
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
    'coins': 271.5,
    'profileImageUrl': null, // Using default icon
  };

  final List<PropertyItem> listings = [
    PropertyItem(
      id: 1,
      imageUrl: 'lib/assets/property4.jpg',
      isVideo: false,
      type: 'House',
      title: 'Modern Luxury Villa',
      location: 'Beverly Hills, CA',
      price: 2500000,
      bedrooms: 5,
      bathrooms: 4,
      area: 4500,
      description: 'Stunning modern villa with panoramic city views, featuring open-plan living spaces, premium finishes, and a resort-style backyard.',
    ),
    PropertyItem(
      id: 2,
      imageUrl: 'lib/assets/apartment1.jpg',
      isVideo: false,
      type: 'Interior',
      title: 'Luxury Interior Design',
      location: 'Los Angeles, CA',
      price: 1800000,
      bedrooms: 3,
      bathrooms: 3,
      area: 3200,
      description: 'Exquisitely designed interior spaces with premium materials and contemporary furnishings throughout.',
    ),
    PropertyItem(
      id: 3,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: true,
      type: 'Building',
      title: 'Modern Architecture',
      location: 'Downtown LA, CA',
      price: 3200000,
      bedrooms: 4,
      bathrooms: 4,
      area: 3800,
      description: 'Architectural masterpiece in the heart of downtown with floor-to-ceiling windows and premium amenities.',
    ),
    PropertyItem(
      id: 4,
      imageUrl: 'lib/assets/property2.jpg',
      isVideo: true,
      type: 'Building',
      title: 'City Skyline View',
      location: 'West Hollywood, CA',
      price: 950000,
      bedrooms: 2,
      bathrooms: 2,
      area: 1850,
      description: 'Breathtaking city views from every room in this sophisticated urban residence.',
    ),
    PropertyItem(
      id: 5,
      imageUrl: 'lib/assets/property4.jpg',
      isVideo: false,
      type: 'Building',
      title: 'Glass Tower',
      location: 'Century City, CA',
      price: 5800000,
      bedrooms: 6,
      bathrooms: 5,
      area: 6200,
      description: 'Luxury penthouse in prestigious glass tower with world-class amenities and concierge services.',
    ),
    PropertyItem(
      id: 6,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: false,
      type: 'House',
      title: 'Lakeside Retreat',
      location: 'Malibu, CA',
      price: 1200000,
      bedrooms: 3,
      bathrooms: 2,
      area: 2800,
      description: 'Serene lakeside property perfect for weekend getaways with private dock and mountain views.',
    ),
    PropertyItem(
      id: 7,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: false,
      type: 'House',
      title: 'Historic Mansion',
      location: 'Pasadena, CA',
      price: 1750000,
      bedrooms: 4,
      bathrooms: 3,
      area: 4200,
      description: 'Beautifully restored historic mansion with original architectural details and modern updates.',
    ),
    PropertyItem(
      id: 8,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: true,
      type: 'Interior',
      title: 'Luxury Bathroom',
      location: 'Beverly Hills, CA',
      price: 1100000,
      bedrooms: 2,
      bathrooms: 3,
      area: 2200,
      description: 'Spa-like luxury bathroom with premium fixtures and finishes throughout the residence.',
    ),
    PropertyItem(
      id: 9,
      imageUrl: 'lib/assets/property2.jpg',
      isVideo: false,
      type: 'Building',
      title: 'Modern Towers',
      location: 'Santa Monica, CA',
      price: 2100000,
      bedrooms: 3,
      bathrooms: 3,
      area: 3100,
      description: 'Contemporary living in Santa Monica with ocean proximity and luxury amenities.',
    ),
  ];

  final List<PropertyItem> clips = [
    PropertyItem(
      id: 10,
      imageUrl: 'lib/assets/apartment1.jpg',
      isVideo: true,
      type: 'Building',
      title: 'Architecture Tour',
      location: 'Downtown LA, CA',
      price: 0,
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      description: 'Virtual tour showcasing innovative architectural design and construction techniques.',
    ),
    PropertyItem(
      id: 11,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: true,
      type: 'Building',
      title: 'Property Walkthrough',
      location: 'West Hollywood, CA',
      price: 0,
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      description: 'Complete property walkthrough highlighting key features and amenities.',
    ),
    PropertyItem(
      id: 12,
      imageUrl:'lib/assets/property4.jpg',
      isVideo: true,
      type: 'Interior',
      title: 'Interior Design Tips',
      location: 'Beverly Hills, CA',
      price: 0,
      bedrooms: 0,
      bathrooms: 0,
      area: 0,
      description: 'Professional interior design tips and trends for luxury living spaces.',
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // Profile Picture Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Form Fields
                    _buildEditField('Name', userProfile['name']),
                    SizedBox(height: 16),
                    _buildEditField('Username', userProfile['username']),
                    SizedBox(height: 16),
                    _buildEditField('Bio', 'Real Estate Professional'),
                    
                    Spacer(),
                    
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Profile updated successfully'),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              margin: EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _shareProfile() {
    HapticFeedback.lightImpact();
    // Simulate copying to clipboard
    Clipboard.setData(ClipboardData(text: 'https://realestate.app/profile/${userProfile['username']}'));
    
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
      builder: (context) => Container(
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
                  _buildDetailedStatRow('Total Posts', '${userProfile['postsCount']}', Icons.grid_on),
                  _buildDetailedStatRow('Followers', '${userProfile['followersCount']}', Icons.people),
                  _buildDetailedStatRow('Following', '${userProfile['followingCount']}', Icons.person_add),
                  _buildDetailedStatRow('Properties Listed', '${listings.length}', Icons.home),
                  _buildDetailedStatRow('Video Content', '${clips.length}', Icons.play_circle_outline),
                  _buildDetailedStatRow('Coins Balance', '${userProfile['coins']}', Icons.monetization_on),
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
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
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

  void _showProfilePicture() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showPropertyDetails(PropertyItem property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Image
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(property.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: property.isVideo
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.black87,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Property Type Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property.type,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    // Title
                    Text(
                      property.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                        SizedBox(width: 4),
                        Text(
                          property.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 15),
                    
                    // Price
                    if (property.price > 0)
                      Text(
                        '\$${(property.price / 1000).toStringAsFixed(0)}K',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
                    // Property Details
                    if (property.bedrooms > 0 || property.bathrooms > 0 || property.area > 0)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (property.bedrooms > 0)
                              _buildPropertyDetailItem(
                                Icons.bed,
                                '${property.bedrooms}',
                                'Bedrooms',
                              ),
                            if (property.bathrooms > 0)
                              _buildPropertyDetailItem(
                                Icons.bathroom,
                                '${property.bathrooms}',
                                'Bathrooms',
                              ),
                            if (property.area > 0)
                              _buildPropertyDetailItem(
                                Icons.square_foot,
                                '${property.area}',
                                'Sq Ft',
                              ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
                    // Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    Text(
                      property.description,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Contact Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Agentscreen()));
          },
                        icon: Icon(Icons.message),
                        label: Text('Contact Agent'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
  }

  Widget _buildPropertyDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(PropertyItem property) {
    return GestureDetector(
      onTap: () => _showPropertyDetails(property),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(property.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (property.isVideo)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black87,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    property.type,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 12,
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              property.location,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (property.price > 0)
                        Text(
                          '\${(property.price / 1000).toStringAsFixed(0)}K',
                          style: TextStyle(
                            color: Colors.green[300],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            HapticFeedback.lightImpact();
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
              size: 20,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _shareProfile,
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.send,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
                    // Top Row - Name
                    Row(
                      children: [
                        Text(
                          userProfile['name'],
                          style: TextStyle(
                            fontSize: 24,
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
                                child: _buildStatColumn('${userProfile['postsCount']}', 'post'),
                              ),
                              GestureDetector(
                                onTap: _showUserStats,
                                child: _buildStatColumn('${userProfile['followersCount']}', 'followers'),
                              ),
                              GestureDetector(
                                onTap: _showUserStats,
                                child: _buildStatColumn('${userProfile['followingCount']}', 'following'),
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
                    
                    // Action Buttons Row
                    Row(
                      children: [
                        // Edit Profile Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _editProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                            ),
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 12),
                        
                        // Coins Display
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${userProfile['coins']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
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
                    listings.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No listings yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start by adding your first property',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: listings.length,
                            itemBuilder: (context, index) {
                              return _buildPropertyCard(listings[index]);
                            },
                          ),
                    
                    // Clips Tab
                    clips.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.videocam_outlined,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No clips yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Create engaging video content',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(16),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: clips.length,
                            itemBuilder: (context, index) {
                              return _buildClipCard(clips[index]);
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClipCard(PropertyItem clip) {
    return GestureDetector(
      onTap: () => _showPropertyDetails(clip),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(clip.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  clip.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PropertyItem class definition
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
}