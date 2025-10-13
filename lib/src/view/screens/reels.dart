import 'package:flutter/material.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<ReelData> reels = [
    ReelData(
      username: 'renex.app',
      videoUrl: 'https://www.instagram.com/reel/DNsKSDk2JPI/',
      caption: 'Rental plot at Kavilakadu ...',
      likes: '245K',
      comments: '1,234',
      shares: '567',
      profileImage: 'https://instagram.fcok6-1.fna.fbcdn.net/v/t51.2885-19/YOUR_PROFILE_IMAGE.jpg',
      isFollowing: false,
      followedBy: 'Followed by aadiiill.___ and 3 others',
      audioName: 'Original Audio',
    ),
    ReelData(
      username: 'renex.app',
      videoUrl: 'https://www.instagram.com/reel/DL9y8nNyMbZ/',
      caption: 'Beautiful properties and land deals\nExplore exclusive real estate opportunities',
      likes: '189K',
      comments: '892',
      shares: '423',
      profileImage: 'https://instagram.fcok6-1.fna.fbcdn.net/v/t51.2885-19/YOUR_PROFILE_IMAGE.jpg',
      isFollowing: false,
      followedBy: 'Followed by 5 others',
      audioName: 'Trending Audio',
    ),
    ReelData(
      username: 'renex.app',
      videoUrl: 'https://www.instagram.com/p/DNsKSDk2JPI/',
      caption: 'Premium rental plots available\nBest locations with all amenities',
      likes: '567K',
      comments: '3,421',
      shares: '1,234',
      profileImage: 'https://instagram.fcok6-1.fna.fbcdn.net/v/t51.2885-19/YOUR_PROFILE_IMAGE.jpg',
      isFollowing: false,
      followedBy: 'Followed by 10 others',
      audioName: 'Original Audio',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: reels.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return ReelItem(reel: reels[index]);
            },
          ),
          // Top bar with back button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 16,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Text(
                    'Reels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26),
                    onPressed: () {
                      // Open camera for creating reels
                      _showToast(context, 'Open Camera');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class ReelItem extends StatefulWidget {
  final ReelData reel;

  const ReelItem({Key? key, required this.reel}) : super(key: key);

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> with SingleTickerProviderStateMixin {
  bool isLiked = false;
  bool isFollowing = false;
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.reel.isFollowing;
    
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _handleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    
    if (isLiked) {
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reverse();
      });
    }
  }

  void _handleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
    _showToast(isFollowing ? 'Following' : 'Unfollowed');
  }

  void _handleComment() {
    _showToast('Open Comments');
    // Show comments bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Comments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No comments yet',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _handleShare() {
    _showToast('Share Reel');
    // Show share options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
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
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.white),
              title: const Text('Copy Link', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Link Copied');
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Share to...', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Opening Share Options');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleRepost() {
    _showToast('Repost Options');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
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
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.repeat, color: Colors.white),
              title: const Text('Repost', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Reposted');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined, color: Colors.white),
              title: const Text('Repost to Story', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Added to Story');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMore() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
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
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.bookmark_outline, color: Colors.white),
              title: const Text('Save', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Saved');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_outlined, color: Colors.white),
              title: const Text('Add to Favorites', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Added to Favorites');
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined, color: Colors.white),
              title: const Text('Report', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showToast('Report Options');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleLike,
      child: Stack(
        children: [
          // Video background with actual image/gradient
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.reel.profileImage),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Fallback to gradient if image fails
                },
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueGrey.shade800,
                  Colors.black87,
                  Colors.blueGrey.shade900,
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Play icon overlay
          Center(
            child: Icon(
              Icons.play_circle_fill_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Right side actions
          Positioned(
            right: 8,
            bottom: 80,
            child: Column(
              children: [
                // Profile with gradient border
                GestureDetector(
                  onTap: () {
                    _showToast('View Profile');
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Container(
                          color: Colors.blue[700],
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Like button with animation
                AnimatedBuilder(
                  animation: _likeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _likeAnimation.value,
                      child: ActionButton(
                        icon: isLiked ? Icons.favorite : Icons.favorite_border,
                        label: widget.reel.likes,
                        color: isLiked ? Colors.red : Colors.white,
                        onTap: _handleLike,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // Comment button - Correct icon
                ActionButton(
                  icon: Icons.mode_comment_outlined,
                  label: widget.reel.comments,
                  onTap: _handleComment,
                ),
                const SizedBox(height: 24),
                
                // Share button - Correct icon (paper plane)
                ActionButton(
                  icon: Icons.send,
                  label: widget.reel.shares,
                  onTap: _handleShare,
                ),
                const SizedBox(height: 24),
                
                // Repost button
                ActionButton(
                  icon: Icons.repeat,
                  label: '',
                  onTap: _handleRepost,
                ),
                const SizedBox(height: 24),
                
                // More options
                ActionButton(
                  icon: Icons.more_vert,
                  label: '',
                  onTap: _handleMore,
                ),
                const SizedBox(height: 20),
                
                // Music album icon with animation
                GestureDetector(
                  onTap: () {
                    _showToast('View Audio');
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom info section
          Positioned(
            left: 12,
            right: 70,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username row with profile and follow button
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Container(
                            color: Colors.blue[700],
                            child: const Center(
                              child: Icon(
                                Icons.store,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.reel.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isFollowing)
                      GestureDetector(
                        onTap: _handleFollow,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Caption
                Text(
                  widget.reel.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.3,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Followed by text
                if (widget.reel.followedBy.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      widget.reel.followedBy,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 12,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Music row
                Row(
                  children: [
                    const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${widget.reel.audioName} • ${widget.reel.username}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3.0,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: color,
              size: 28,
              shadows: const [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 4.0,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReelData {
  final String username;
  final String videoUrl;
  final String caption;
  final String likes;
  final String comments;
  final String shares;
  final String profileImage;
  final bool isFollowing;
  final String followedBy;
  final String audioName;

  ReelData({
    required this.username,
    required this.videoUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.profileImage,
    required this.isFollowing,
    required this.followedBy,
    required this.audioName,
  });
}