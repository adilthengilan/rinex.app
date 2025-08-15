

import 'package:flutter/material.dart';
import 'package:rinex/src/view/screens/agentlist.dart';
import 'package:rinex/src/view/screens/favourites.dart' show FavoriteScreen;
import 'package:rinex/src/view/screens/searchpage.dart';

class SharedFavoriteManager {
  static final SharedFavoriteManager _instance = SharedFavoriteManager._internal();
  factory SharedFavoriteManager() => _instance;
  SharedFavoriteManager._internal();

  final Set<String> _favoriteProperties = <String>{};
  
  Set<String> get favoriteProperties => _favoriteProperties;
  
  bool isFavorite(String propertyId) => _favoriteProperties.contains(propertyId);
  
  void addFavorite(String propertyId) => _favoriteProperties.add(propertyId);
  
  void removeFavorite(String propertyId) => _favoriteProperties.remove(propertyId);
  
  void toggleFavorite(String propertyId) {
    if (_favoriteProperties.contains(propertyId)) {
      _favoriteProperties.remove(propertyId);
    } else {
      _favoriteProperties.add(propertyId);
    }
  }
  
  void clearAllFavorites() => _favoriteProperties.clear();
  
  int get favoriteCount => _favoriteProperties.length;
  
  // Get favorite properties with full data
  List<Map<String, dynamic>> getFavoriteProperties() {
    final allProperties = PropertyDataService.getAllProperties();
    return allProperties.where((prop) => _favoriteProperties.contains(prop['id'])).toList();
  }
}

// Centralized Property Data Service
class PropertyDataService {
  static List<Map<String, dynamic>> getAllProperties() {
    return [
      {
        'id': 'prop_1',
        'imageUrl': 'lib/assets/property4.jpg',
        'propertyName': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '₹ 10,000 /month',
        'beds': '3 BHK',
        'area': 'Area: 1000 Sqft',
        'bedrooms': 'Bedrooms: 03',
        'bathrooms': 'Bathrooms: 03',
        'kitchen': 'Kitchen: 01',
        'parking': 'Parking Available',
        'furnished': 'Semi Furnished',
        'year': '2022',
        'rating': '4.9',
        'description': 'Beautiful apartment with modern amenities in the heart of Jakarta.',
        'amenities': ['Swimming Pool', 'Gym', '24/7 Security', 'Elevator'],
      },
      {
        'id': 'prop_2',
        'imageUrl': 'lib/assets/property2.jpg',
        'propertyName': 'Charming Family Home',
        'location': 'San Francisco, USA',
        'price': '₹ 10,000 /month',
        'beds': '3 BHK',
        'area': 'Area: 1200 Sqft',
        'bedrooms': 'Bedrooms: 04',
        'bathrooms': 'Bathrooms: 02',
        'kitchen': 'Kitchen: 01',
        'parking': 'Parking Available',
        'furnished': 'Unfurnished',
        'year': '2005',
        'rating': '4.5',
        'description': 'Spacious family home perfect for growing families.',
        'amenities': ['Garden', 'Garage', 'Fireplace', 'Basement'],
      },
      {
        'id': 'prop_3',
        'imageUrl': 'lib/assets/building.jpg',
        'propertyName': 'Modern Building Complex',
        'location': 'Jakarta, Indonesia',
        'price': '₹ 12,000 /month',
        'beds': '2 BHK',
        'area': 'Area: 800 Sqft',
        'bedrooms': 'Bedrooms: 02',
        'bathrooms': 'Bathrooms: 02',
        'kitchen': 'Kitchen: 01',
        'parking': 'Parking Available',
        'furnished': 'Fully Furnished',
        'year': '2023',
        'rating': '4.7',
        'description': 'Ultra-modern apartment with smart home features.',
        'amenities': ['Smart Home', 'Rooftop Terrace', 'Concierge', 'Spa'],
      },
      {
        'id': 'prop_4',
        'imageUrl': 'lib/assets/property4.jpg',
        'propertyName': 'Luxury Villa',
        'location': 'Mumbai, India',
        'price': '₹ 25,000 /month',
        'beds': '5 BHK',
        'area': 'Area: 2500 Sqft',
        'bedrooms': 'Bedrooms: 05',
        'bathrooms': 'Bathrooms: 04',
        'kitchen': 'Kitchen: 02',
        'parking': 'Parking Available',
        'furnished': 'Fully Furnished',
        'year': '2024',
        'rating': '4.8',
        'description': 'Luxurious villa with premium amenities and stunning views.',
        'amenities': ['Private Pool', 'Home Theater', 'Wine Cellar', 'Maid Service'],
      },
    ];
  }
}

class Propertylist extends StatefulWidget {
  const Propertylist({super.key});

  @override
  State<Propertylist> createState() => _PropertylistState();
}

class _PropertylistState extends State<Propertylist> {
  String _currentLocation = '34.0522° N, 118.2437° W';
  final SharedFavoriteManager _favoriteManager = SharedFavoriteManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.blue, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Agentscreen()),
                  );
                },
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.blue, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                  ).then((_) {
                    // Refresh the property list when returning from favorites
                    setState(() {});
                  });
                },
              ),
              if (_favoriteManager.favoriteCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_favoriteManager.favoriteCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLocationAndSortFilter(),
            _buildPropertyList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  SearchPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              "Search House, Apartment, etc",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationAndSortFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.sort, size: 20, color: Colors.grey),
                SizedBox(width: 5),
                Text("Sort by", style: TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  _currentLocation,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList() {
    final properties = PropertyDataService.getAllProperties();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final bool isFavorite = _favoriteManager.isFavorite(property['id']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Stack(
              children: [
                Hero(
                  tag: 'property_${property['id']}',
                  child: Image.asset(
                    property['imageUrl'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://placehold.co/400x200/E0E0E0/333333?text=Image+Error',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(property),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFavorite ? Colors.red.withOpacity(0.9) : Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.white : Colors.red,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007BFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "renex assured",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property['propertyName'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Text(
                      property['price'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007BFF),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      property['location'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.king_bed, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      property['beds'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      property['rating'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _buildDetailRow(Icons.area_chart, property['area']),
                _buildDetailRow(Icons.king_bed, property['bedrooms']),
                _buildDetailRow(Icons.bathtub, property['bathrooms']),
                _buildDetailRow(Icons.kitchen, property['kitchen']),
                _buildDetailRow(Icons.directions_car, property['parking']),
                _buildDetailRow(Icons.chair, property['furnished']),
                _buildDetailRow(Icons.calendar_today, property['year']),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewPropertyDetails(property),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Details'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Agentscreen()));
          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.call, size: 16),
                        label: const Text('Contact'),
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

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> property) {
    setState(() {
      _favoriteManager.toggleFavorite(property['id']);
    });
    
    final bool isNowFavorite = _favoriteManager.isFavorite(property['id']);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowFavorite 
            ? 'Added "${property['propertyName']}" to favorites'
            : 'Removed "${property['propertyName']}" from favorites',
        ),
        action: SnackBarAction(
          label: 'View Favorites',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteScreen()),
            ).then((_) => setState(() {}));
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewPropertyDetails(Map<String, dynamic> property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for ${property['propertyName']}')),
    );
  }

  void _contactOwner(Map<String, dynamic> property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contacting owner of ${property['propertyName']}')),
    );
  }
}