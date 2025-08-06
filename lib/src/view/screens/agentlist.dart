import 'package:flutter/material.dart';



class RealEstateAgentsScreen extends StatefulWidget {
  const RealEstateAgentsScreen({super.key});

  @override
  _RealEstateAgentsScreenState createState() => _RealEstateAgentsScreenState();
}

class _RealEstateAgentsScreenState extends State<RealEstateAgentsScreen> {
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
      propertyCount: 156,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "Michael Brown",
      company: "Luxury Homes",
      propertyCount: 203,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "Emily Davis",
      company: "City Properties",
      propertyCount: 134,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
    Agent(
      name: "David Wilson",
      company: "Metro Real Estate",
      propertyCount: 178,
      profileImage: "lib/assets/buyer.jpg",
      isVerified: true,
    ),
  ];

  List<Agent> filteredAgents = [];
  int _currentIndex = 0;

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
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
      title: Text(title),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search and Sort Section
            Container(
              padding: EdgeInsets.all(16),
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
              child: Row(
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
                        decoration: InputDecoration(
                          hintText: 'Search House, Apartment, etc',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.blue[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
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
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune,
                            color: Colors.blue[400],
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
            ),
            
            // Agents Count
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredAgents.length} Real Estate Agents',
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
      
      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business_outlined),
              activeIcon: Icon(Icons.business),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: '',
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
        title: Text('Call ${agent.name}'),
        content: Text('Would you like to call ${agent.name} from ${agent.company}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would implement actual calling functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${agent.name}...')),
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
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
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.blue[400],
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
                        Text(
                          agent.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (agent.isVerified) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
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
                child: OutlinedButton(
                  onPressed: onCall,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.blue,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 12),
              
              // Follow Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: agent.isFollowed ? Colors.grey : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    agent.isFollowed ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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