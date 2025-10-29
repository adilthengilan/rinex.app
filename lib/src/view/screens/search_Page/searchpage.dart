import 'package:flutter/material.dart';
import 'package:rinex/src/view/screens/favorites_Page/favourites.dart';
import 'package:rinex/src/view/screens/notification_Page/notifications.dart';
import 'package:rinex/src/view/screens/propertyListing_Page/propertylist.dart';

class Searchpage extends StatefulWidget {
  final String? searchQuery;

  const Searchpage({super.key, this.searchQuery});

  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final TextEditingController _searchController = TextEditingController();
  final SharedFavoriteManager _favoriteManager = SharedFavoriteManager();
  List<Property> allProperties = [];
  List<Property> filteredProperties = [];
  String selectedSort = 'Default';

  @override
  void initState() {
    super.initState();

    // Initialize property data with property types
    allProperties = [
      Property(
        id: 'prop_1',
        imageUrl: 'assets/property4.jpg',
        title: 'Sky Dandelions Apartment',
        location: 'Jakarta, Indonesia',
        rating: 4.9,
        price: 10000,
        area: '1000 Sqft',
        bedrooms: '03',
        bathrooms: '03',
        kitchen: '01',
        yearBuilt: '2022',
        isLiked: false,
        type: 'Apartment',
      ),
      Property(
        id: 'prop_2',
        imageUrl: 'assets/property2.jpg',
        title: 'Luxury Villa Paradise',
        location: 'Bali, Indonesia',
        rating: 4.9,
        price: 15000,
        area: '1200 Sqft',
        bedrooms: '04',
        bathrooms: '03',
        kitchen: '01',
        yearBuilt: '2021',
        isLiked: false,
        type: 'Villa',
      ),
      Property(
        id: 'prop_3',
        imageUrl: 'assets/apartment1.jpg',
        title: 'Modern City Apartment',
        location: 'Jakarta, Indonesia',
        rating: 4.7,
        price: 8000,
        area: '900 Sqft',
        bedrooms: '02',
        bathrooms: '02',
        kitchen: '01',
        yearBuilt: '2023',
        isLiked: false,
        type: 'Apartment',
      ),
      Property(
        id: 'prop_4',
        imageUrl: 'assets/building.jpg',
        title: 'Commercial Building Complex',
        location: 'Jakarta, Indonesia',
        rating: 4.8,
        price: 25000,
        area: '2000 Sqft',
        bedrooms: '05',
        bathrooms: '04',
        kitchen: '02',
        yearBuilt: '2020',
        isLiked: false,
        type: 'Building',
      ),
      Property(
        id: 'prop_5',
        imageUrl: 'assets/property4.jpg',
        title: 'Cozy Family House',
        location: 'Surabaya, Indonesia',
        rating: 4.6,
        price: 12000,
        area: '1500 Sqft',
        bedrooms: '03',
        bathrooms: '02',
        kitchen: '01',
        yearBuilt: '2019',
        isLiked: false,
        type: 'House',
      ),
    ];

    filteredProperties = List.from(allProperties);
    _loadFavoriteStates();

    // If searchQuery is provided, apply filter
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      _searchController.text = widget.searchQuery!;
      _filterProperties(widget.searchQuery!);
    }
  }

  void _loadFavoriteStates() {
    List<Map<String, dynamic>> favorites = _favoriteManager
        .getFavoriteProperties();
    Set<String> favoriteIds = favorites
        .map((fav) => fav['id'].toString())
        .toSet();

    setState(() {
      for (var property in allProperties) {
        property.isLiked = favoriteIds.contains(property.id);
      }
      for (var property in filteredProperties) {
        property.isLiked = favoriteIds.contains(property.id);
      }
    });
  }

  void _filterProperties(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProperties = List.from(allProperties);
      } else {
        filteredProperties = allProperties.where((property) {
          return property.title.toLowerCase().contains(query.toLowerCase()) ||
              property.location.toLowerCase().contains(query.toLowerCase()) ||
              property.type.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _sortProperties(String sortType) {
    setState(() {
      selectedSort = sortType;
      switch (sortType) {
        case 'Price: Low to High':
          filteredProperties.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          filteredProperties.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Rating':
          filteredProperties.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        default:
          filteredProperties = List.from(allProperties);
          if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
            _filterProperties(widget.searchQuery!);
          }
      }
    });
  }

  void _toggleFavorite(Property property) {
    setState(() {
      property.isLiked = !property.isLiked;

      if (property.isLiked) {
        _favoriteManager.addFavorite(property.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${property.title}" to favorites'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()),
                );
              },
            ),
          ),
        );
      } else {
        _favoriteManager.removeFavorite(property.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed "${property.title}" from favorites'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  property.isLiked = true;
                  _favoriteManager.addFavorite(property.id);
                });
              },
            ),
          ),
        );
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildSortOption('Default'),
              _buildSortOption('Price: Low to High'),
              _buildSortOption('Price: High to Low'),
              _buildSortOption('Rating'),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String option) {
    return ListTile(
      title: Text(option),
      trailing: selectedSort == option
          ? Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        _sortProperties(option);
        Navigator.pop(context);
      },
    );
  }

  void _navigateToNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  void _navigateToFavorites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteScreen()),
    );
    _loadFavoriteStates();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        bottomNavigationBar: BottomAppBar(color: Colors.transparent),
        body: Column(
          children: [
            _buildSearchHeader(),
            _buildLocationSortBar(),
            Expanded(
              child: filteredProperties.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No properties found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredProperties.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: _buildPropertyCard(
                            property: filteredProperties[index],
                            onLikePressed: () {
                              _toggleFavorite(filteredProperties[index]);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
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
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.blue, size: 20),
          ),
          SizedBox(width: 8),
          Icon(Icons.search, color: Colors.blue, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _filterProperties,
              decoration: InputDecoration(
                hintText: 'Search Apartment, Villa, Building, House',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          GestureDetector(
            onTap: _navigateToNotifications,
            child: Stack(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.blue,
                    size: 18,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: _navigateToFavorites,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border, color: Colors.blue, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSortBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showSortOptions,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.unfold_more_outlined,
                    color: Colors.blue,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: Colors.blue, size: 18),
                SizedBox(width: 4),
                Text(
                  '34.0522° N, 118.2437° W',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard({
    required Property property,
    required VoidCallback onLikePressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    property.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: GestureDetector(
                  onTap: onLikePressed,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      property.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '₹${property.price}/month',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text(
                      property.location,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey[700], size: 14),
                          SizedBox(width: 4),
                          Text(
                            property.type,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.star, color: Colors.orange, size: 16),
                    SizedBox(width: 2),
                    Text(
                      property.rating.toString(),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureItem(
                        icon: Icons.square_foot,
                        label: 'Area',
                        value: property.area,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureItem(
                        icon: Icons.chair,
                        label: 'Semi Furnished',
                        value: '',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureItem(
                        icon: Icons.bed,
                        label: 'Bedrooms',
                        value: property.bedrooms,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureItem(
                        icon: Icons.local_parking,
                        label: 'Parking Available',
                        value: '',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureItem(
                        icon: Icons.bathtub,
                        label: 'Bathrooms',
                        value: property.bathrooms,
                      ),
                    ),
                    Expanded(
                      child: _buildFeatureItem(
                        icon: Icons.calendar_today,
                        label: property.yearBuilt,
                        value: '',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildFeatureItem(
                  icon: Icons.kitchen,
                  label: 'Kitchen',
                  value: property.kitchen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 18),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isNotEmpty ? '$label:$value' : label,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Property Model Class
class Property {
  final String id;
  final String imageUrl;
  final String title;
  final String location;
  final double rating;
  final int price;
  final String area;
  final String bedrooms;
  final String bathrooms;
  final String kitchen;
  final String yearBuilt;
  final String type;
  bool isLiked;

  Property({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchen,
    required this.yearBuilt,
    required this.isLiked,
    required this.type,
  });
}
