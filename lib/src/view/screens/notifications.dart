import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Current selected bottom navigation index
  int _selectedIndex = 0;
  
  // List of notification data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Example name',
      message: 'New message received from a potential buyer',
      timestamp: 'Now',
      isVerified: true,
      avatarAsset: 'lib/assets/buyer.jpg',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Renex App',
      message: 'Your property has been successfully added!',
      timestamp: 'Now',
      isVerified: true,
      avatarAsset: 'lib/assets/renx.jpg',
      isRead: false,
      isAppNotification: true,
    ),
    NotificationItem(
      id: '3',
      title: 'Example name',
      message: 'New message received from a potential buyer',
      timestamp: 'Tue',
      isVerified: true,
      avatarAsset: 'lib/assets/buyer.jpg',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Example name',
      message: 'New message received from a potential buyer',
      timestamp: 'Mon',
      isVerified: true,
      avatarAsset: 'lib/assets/buyer.jpg',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C), // Dark background
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),
            
            // Notification List
            Expanded(
              child: _buildNotificationList(),
            ),
          ],
        ),
      ),
      
    
    );
  }

  /// Builds the custom app bar with notification title
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Title
          const Text(
            'Notification',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          
          // Optional: Add more actions here (settings, search, etc.)
          IconButton(
            onPressed: _clearAllNotifications,
            icon: const Icon(
              Icons.clear_all,
              color: Colors.white70,
            ),
            tooltip: 'Clear all notifications',
          ),
        ],
      ),
    );
  }

  /// Builds the scrollable list of notifications
  Widget _buildNotificationList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(_notifications[index], index);
        },
      ),
    );
  }

  /// Builds individual notification card
  Widget _buildNotificationCard(NotificationItem notification, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () => _onNotificationTap(notification),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Avatar/Icon
                _buildAvatar(notification),
                
                const SizedBox(width: 12.0),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with verification badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (notification.isVerified) ...[
                            const SizedBox(width: 4.0),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF1DA1F2),
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 4.0),
                      
                      // Message
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8.0),
                
                // Timestamp and status indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      notification.timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    
                    // Unread indicator
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1DA1F2),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds avatar/icon based on notification type
  Widget _buildAvatar(NotificationItem notification) {
    if (notification.isAppNotification) {
      // App logo for app notifications
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1DA1F2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            notification.avatarAsset,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback for missing asset
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1DA1F2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
        ),
      );
    } else {
      // User avatar for user notifications
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Image.asset(
            notification.avatarAsset,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback for missing asset
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 24,
                ),
              );
            },
          ),
        ),
      );
    }
  }

 
  // Event Handlers

  /// Handles notification tap - marks as read and navigates
  void _onNotificationTap(NotificationItem notification) {
    setState(() {
      // Mark notification as read
      notification.isRead = true;
    });

    // Handle navigation based on notification type
    if (notification.isAppNotification) {
      _navigateToPropertyDetails(notification);
    } else {
      _navigateToChat(notification);
    }

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${notification.title}'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF1DA1F2),
      ),
    );
  }

  /// Handles bottom navigation tap
  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on selected tab
    switch (index) {
      case 0:
        _navigateToHome();
        break;
      case 1:
        _navigateToProperties();
        break;
      case 2:
        _showAddPropertyBottomSheet();
        break;
      case 3:
        _navigateToMedia();
        break;
      case 4:
        _navigateToProfile();
        break;
    }
  }

  /// Clears all notifications
  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Notifications'),
          content: const Text('Are you sure you want to clear all notifications?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _notifications.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications cleared'),
                    backgroundColor: Color(0xFF1DA1F2),
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  // Navigation Methods

  /// Navigate to home screen
  void _navigateToHome() {
    debugPrint('Navigating to Home');
    // Navigator.pushReplacementNamed(context, '/home');
  }

  /// Navigate to properties list
  void _navigateToProperties() {
    debugPrint('Navigating to Properties');
    // Navigator.pushNamed(context, '/properties');
  }

  /// Navigate to chat with user
  void _navigateToChat(NotificationItem notification) {
    debugPrint('Navigating to chat with ${notification.title}');
    // Navigator.pushNamed(context, '/chat', arguments: notification.id);
  }

  /// Navigate to property details
  void _navigateToPropertyDetails(NotificationItem notification) {
    debugPrint('Navigating to property details');
    // Navigator.pushNamed(context, '/property-details', arguments: notification.id);
  }

  /// Navigate to media screen
  void _navigateToMedia() {
    debugPrint('Navigating to Media');
    // Navigator.pushNamed(context, '/media');
  }

  /// Navigate to profile screen
  void _navigateToProfile() {
    debugPrint('Navigating to Profile');
    // Navigator.pushNamed(context, '/profile');
  }

  /// Show add property bottom sheet
  void _showAddPropertyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add New Property',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add property form or options here
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                debugPrint('Add property functionality');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DA1F2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Add Property',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Data model for notification items
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final bool isVerified;
  final String avatarAsset;
  bool isRead;
  final bool isAppNotification;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isVerified,
    required this.avatarAsset,
    this.isRead = false,
    this.isAppNotification = false,
  });
}

/// Example usage in main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renex Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const NotificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}