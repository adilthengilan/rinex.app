
import 'package:flutter/material.dart';

class Propertylist extends StatefulWidget {
  const Propertylist({super.key});

  @override
  State<Propertylist> createState() => _PropertylistState();
}

class _PropertylistState extends State<Propertylist> {
  // Placeholder for location, as actual fetching requires geolocator setup
  String _currentLocation = '34.0522° N, 118.2437° W';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blue, size: 28),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.blue, size: 28),
            onPressed: () {
              // Handle favorite icon tap
            },
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Lighter grey for search bar background
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search House, Apartment, etc",
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(fontSize: 16),
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
    final List<Map<String, dynamic>> properties = [
      {
        'imageUrl': 'lib/assets/property4.jpg',
        'propertyName': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '₹ 10,000 /month',
        'beds': '3 BHK',
        'area': 'Area:1000 Sqft',
        'bedrooms': 'Bedrooms :03',
        'bathrooms': 'Bathrooms:03',
        'kitchen': 'Kitchen:01',
        'parking': 'Parking Availabile',
        'furnished': 'Semi Furnished',
        'year': '2022',
        'rating': '4.9',
      },
      {
        'imageUrl': 'lib/assets/property2.jpg',
        'propertyName': 'Charming Family Home',
        'location': 'San Francisco, USA',
        'price': '₹ 10,000 /month', // Keeping price consistent with image
        'beds': '3 BHK', // Keeping beds consistent with image
        'area': 'Area:1200 Sqft',
        'bedrooms': 'Bedrooms :04',
        'bathrooms': 'Bathrooms:02',
        'kitchen': 'Kitchen:01',
        'parking': 'Parking Availabile',
        'furnished': 'Unfurnished',
        'year': '2005',
        'rating': '4.5',
      },
       {
        'imageUrl': 'lib/assets/building.jpg',
        'propertyName': 'Sky Dandelions Apartment',
        'location': 'Jakarta, Indonesia',
        'price': '₹ 10,000 /month',
        'beds': '3 BHK',
        'area': 'Area:1000 Sqft',
        'bedrooms': 'Bedrooms :03',
        'bathrooms': 'Bathrooms:03',
        'kitchen': 'Kitchen:01',
        'parking': 'Parking Availabile',
        'furnished': 'Semi Furnished',
        'year': '2022',
        'rating': '4.9',
      },
      // Add more properties as needed
    ];

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
                Image.asset(
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
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, color: Colors.blue, size: 20), // Blue favorite icon
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
                    Text(
                      property['propertyName'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
}
