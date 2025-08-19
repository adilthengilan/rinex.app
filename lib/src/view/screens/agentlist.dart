import 'package:flutter/material.dart';

class Agentscreen extends StatefulWidget {
  const Agentscreen({super.key});

  @override
  _AgentscreenState createState() => _AgentscreenState();
}

class _AgentscreenState extends State<Agentscreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Agent> agents = [
    Agent(
      name: "John Smith",
      company: "Premium Properties",
      propertyCount: 189,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "Sarah Johnson",
      company: "Elite Real Estate",
      propertyCount: 189,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "Michael Brown",
      company: "Luxury Homes",
      propertyCount: 189,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "Emily Davis",
      company: "City Properties",
      propertyCount: 189,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "David Wilson",
      company: "Metro Real Estate",
      propertyCount: 189,
      profileImage:"lib/assets/buyer.jpg",
      isVerified: true,
    ),
  ];

  List<Agent> filteredAgents = [];
  int totalAgentsCount = 2765; // Total count as shown in design

  @override
  void initState() {
    super.initState();
    filteredAgents = agents;
  }

  void _filterAgents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAgents = agents;
      } else {
        filteredAgents = agents
            .where((agent) =>
                agent.name.toLowerCase().contains(query.toLowerCase()) ||
                agent.company.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
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
              SizedBox(height: 20),
              Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              _buildSortOption('Name (A-Z)', () => _sortByName()),
              _buildSortOption('Properties (High to Low)', () => _sortByProperties(true)),
              _buildSortOption('Properties (Low to High)', () => _sortByProperties(false)),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _sortByName() {
    setState(() {
      filteredAgents.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void _sortByProperties(bool descending) {
    setState(() {
      if (descending) {
        filteredAgents.sort((a, b) => b.propertyCount.compareTo(a.propertyCount));
      } else {
        filteredAgents.sort((a, b) => a.propertyCount.compareTo(b.propertyCount));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button and Search/Sort Section
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 20),
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
              child: Column(
                children: [
                  // Back Button Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.black87,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Search and Sort Row
                  Row(
                    children: [
                      // Search Field
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterAgents,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search House, Apartment, etc',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF4A90E2),
                                size: 22,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Sort Button
                      GestureDetector(
                        onTap: _showSortOptions,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune,
                                color: Color(0xFF4A90E2),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sort by',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
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
            
            // Agents Count
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$totalAgentsCount Real Estate Agents',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // Agents List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredAgents.length,
                itemBuilder: (context, index) {
                  return AgentCard(
                    agent: filteredAgents[index],
                    onCall: () => _callAgent(filteredAgents[index]),
                    onFollow: () => _followAgent(filteredAgents[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callAgent(Agent agent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text('Call ${agent.name}'),
        content: Text('Would you like to call ${agent.name} from ${agent.company}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${agent.name}...'),
                  backgroundColor: Color(0xFF4A90E2),
                ),
              );
            },
            child: Text('Call'),
          ),
        ],
      ),
    );
  }

  void _followAgent(Agent agent) {
    setState(() {
      agent.isFollowed = !agent.isFollowed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          agent.isFollowed 
            ? 'Following ${agent.name}' 
            : 'Unfollowed ${agent.name}'
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4A90E2),
      ),
    );
  }
}

class AgentCard extends StatelessWidget {
  final Agent agent;
  final VoidCallback onCall;
  final VoidCallback onFollow;

  const AgentCard({
    Key? key,
    required this.agent,
    required this.onCall,
    required this.onFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    agent.profileImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to a professional-looking avatar if image fails
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 16),
              
              // Agent Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            agent.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (agent.isVerified) ...[
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF4A90E2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      agent.company,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Properties Count
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${agent.propertyCount} Properties',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              // Call Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF4A90E2), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: Icon(
                    Icons.phone,
                    color: Color(0xFF4A90E2),
                    size: 18,
                  ),
                  label: Text(
                    'Call',
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Follow Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: agent.isFollowed ? Colors.grey[400] : Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Text(
                    agent.isFollowed ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}

class Agent {
  final String name;
  final String company;
  final int propertyCount;
  final String profileImage;
  final bool isVerified;
  bool isFollowed;

  Agent({
    required this.name,
    required this.company,
    required this.propertyCount,
    required this.profileImage,
    this.isVerified = false,
    this.isFollowed = false,
  });
}