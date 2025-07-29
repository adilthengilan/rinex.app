import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Property> favoriteProperties;

  const FavoriteScreen({Key? key, required this.favoriteProperties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Color(0xFF007BFF),
        foregroundColor: Colors.white,
      ),
      body: favoriteProperties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start adding properties to your favorites',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: favoriteProperties.length,
              itemBuilder: (context, index) {
                final property = favoriteProperties[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        property.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(property.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(property.location),
                        Text(property.price, style: TextStyle(color: Color(0xFF007BFF))),
                      ],
                    ),
                    trailing: Icon(Icons.favorite, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}

// Property Model
class Property {
  final String id;
  final String name;
  final String location;
  final String price;
  final String beds;
  final double rating;
  final String imageUrl;

  Property({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.beds,
    required this.rating,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Property && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
