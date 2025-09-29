import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchTerm = '';
  String _sortBy = 'newest';
  final TextEditingController _searchController = TextEditingController();

  final List<PropertyItem> _allProperties = [
    PropertyItem(
      id: 1,
      imageUrl: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=300&fit=crop',
      isVideo: false,
      type: 'House',
      title: 'Modern Luxury Villa',
      location: 'Beverly Hills, CA',
      price: 2500000,
      beds: 4,
      baths: 3,
      sqft: 3200,
      aspectRatio: 2.0,
    ),
    PropertyItem(
      id: 2,
      imageUrl: 'lib/assets/apartment1.jpg',
      isVideo: false,
      type: 'Apartment',
      title: 'Downtown Penthouse',
      location: 'Los Angeles, CA',
      price: 1800000,
      beds: 3,
      baths: 2,
      sqft: 2100,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 3,
      imageUrl: 'lib/assets/property4.jpg',
      isVideo: true,
      type: 'House',
      title: 'Contemporary Family Home',
      location: 'Santa Monica, CA',
      price: 3200000,
      beds: 5,
      baths: 4,
      sqft: 4100,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 4,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: true,
      type: 'Apartment',
      title: 'High-Rise Condo',
      location: 'West Hollywood, CA',
      price: 950000,
      beds: 2,
      baths: 2,
      sqft: 1400,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 5,
      imageUrl: 'lib/assets/building.jpg',
      isVideo: true,
      type: 'House',
      title: 'Beachfront Property',
      location: 'Malibu, CA',
      price: 5800000,
      beds: 6,
      baths: 5,
      sqft: 5200,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 6,
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=400&h=300&fit=crop',
      isVideo: false,
      type: 'Apartment',
      title: 'Luxury Loft',
      location: 'Downtown LA, CA',
      price: 1200000,
      beds: 2,
      baths: 1,
      sqft: 1800,
      aspectRatio: 1.5,
    ),
    PropertyItem(
      id: 7,
      imageUrl: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=400&fit=crop',
      isVideo: false,
      type: 'House',
      title: 'Spanish Colonial',
      location: 'Pasadena, CA',
      price: 1750000,
      beds: 4,
      baths: 3,
      sqft: 2800,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 8,
      imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=400&h=400&fit=crop',
      isVideo: false,
      type: 'Condo',
      title: 'Modern Townhouse',
      location: 'Culver City, CA',
      price: 1100000,
      beds: 3,
      baths: 2,
      sqft: 1950,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 9,
      imageUrl: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'House',
      title: 'Mid-Century Modern',
      location: 'Palm Springs, CA',
      price: 2100000,
      beds: 3,
      baths: 3,
      sqft: 2400,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 10,
      imageUrl: 'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'Apartment',
      title: 'Urban Studio',
      location: 'Hollywood, CA',
      price: 750000,
      beds: 1,
      baths: 1,
      sqft: 900,
      aspectRatio: 1.0,
    ),
    PropertyItem(
      id: 11,
      imageUrl: 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=400&h=400&fit=crop',
      isVideo: true,
      type: 'House',
      title: 'Garden Estate',
      location: 'Bel Air, CA',
      price: 4200000,
      beds: 5,
      baths: 4,
      sqft: 4800,
      aspectRatio: 1.0,
    ),
  ];

  List<PropertyItem> get _filteredAndSortedProperties {
    List<PropertyItem> filtered = _allProperties.where((property) {
      return property.title.toLowerCase().contains(_searchTerm.toLowerCase()) ||
             property.type.toLowerCase().contains(_searchTerm.toLowerCase()) ||
             property.location.toLowerCase().contains(_searchTerm.toLowerCase());
    }).toList();

    switch (_sortBy) {
      case 'price-low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'size':
        filtered.sort((a, b) => b.sqft.compareTo(a.sqft));
        break;
      case 'newest':
      default:
        // Keep original order
        break;
    }

    return filtered;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value;
    });
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _sortBy = value;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProperties = _filteredAndSortedProperties;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFB8BCC8), Color(0xFFA1A5B1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Back Arrow and Title Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Navigate back to home screen
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Search Properties',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.blue[600], size: 24),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: const InputDecoration(
                              hintText: 'Search House, Apartment, etc',
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (_searchTerm.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            child: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sort and Location Row
                  Row(
                    children: [
                      // Sort By Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            onChanged: _onSortChanged,
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue[600]),
                            items: const [
                              DropdownMenuItem(value: 'newest', child: Text('Newest')),
                              DropdownMenuItem(value: 'price-low', child: Text('Price: Low-High')),
                              DropdownMenuItem(value: 'price-high', child: Text('Price: High-Low')),
                              DropdownMenuItem(value: 'size', child: Text('Size: Largest')),
                            ],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Location Button
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.blue[600], size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  '34.0522° N, 118.2437° W',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
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

            // Results Counter
            if (filteredProperties.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      '${filteredProperties.length} ${filteredProperties.length == 1 ? 'Property' : 'Properties'} Found',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            // Properties Grid
            Expanded(
              child: filteredProperties.isEmpty
                  ? _buildEmptyState()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.75,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return PropertyCard(property: filteredProperties[index]);
                              },
                              childCount: filteredProperties.length,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20), // Bottom padding
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🏠',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          const Text(
            'No properties found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
        ],
      ),
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
  final int beds;
  final int baths;
  final int sqft;
  final double aspectRatio;

  PropertyItem({
    required this.id,
    required this.imageUrl,
    required this.isVideo,
    required this.type,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.aspectRatio,
  });

  String get formattedPrice {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$$price';
    }
  }

  String get formattedSqft {
    return '${sqft.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} sqft';
  }
}

class PropertyCard extends StatelessWidget {
  final PropertyItem property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Property detail navigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing ${property.title}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Property Image
              Image.network(
                property.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                      size: 50,
                    ),
                  );
                },
              ),

              // Property Type Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    property.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Video Play Button Overlay
              if (property.isVideo)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.blue[600],
                      size: 24,
                    ),
                  ),
                ),

              // Bottom Gradient and Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[300],
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.location,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            property.formattedPrice,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${property.beds}bd • ${property.baths}ba • ${property.formattedSqft}',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 10,
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
}