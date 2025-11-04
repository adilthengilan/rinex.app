
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rinex/src/view/screens/favorites_Page/favourites.dart';
import 'package:rinex/src/view/screens/search_Page/searchpage.dart';

class ShuffleScreen extends StatefulWidget {
  const ShuffleScreen({super.key});

  @override
  State<ShuffleScreen> createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Simplified property data - only images with type
  final List<PropertyItemData> allProperties = [
    PropertyItemData(
      id: 1,
      image: 'assets/apartment1.jpg',
      isVideo: false,
      aspectRatio: 1.5,
      type: 'Apartment',
    ),
    PropertyItemData(
      id: 2,
      image: 'assets/building.jpg',
      isVideo: false,
      aspectRatio: 1.2,
      type: 'Building',
    ),
    PropertyItemData(
      id: 3,
      image: 'assets/property4.jpg',
      isVideo: true,
      aspectRatio: 1.0,
      type: 'House',
    ),
    PropertyItemData(
      id: 4,
      image: 'assets/property2.jpg',
      isVideo: true,
      aspectRatio: 1.3,
      type: 'Villa',
    ),
    PropertyItemData(
      id: 5,
      image: 'assets/building.jpg',
      isVideo: true,
      aspectRatio: 1.0,
      type: 'Building',
    ),
    PropertyItemData(
      id: 6,
      image: 'assets/property2.jpg',
      isVideo: false,
      aspectRatio: 1.4,
      type: 'Villa',
    ),
    PropertyItemData(
      id: 7,
      image: 'assets/apartment1.jpg',
      isVideo: false,
      aspectRatio: 1.0,
      type: 'Apartment',
    ),
    PropertyItemData(
      id: 8,
      image: 'assets/property4.jpg',
      isVideo: false,
      aspectRatio: 1.2,
      type: 'House',
    ),
    PropertyItemData(
      id: 9,
      image: 'assets/property2.jpg',
      isVideo: true,
      aspectRatio: 1.0,
      type: 'Villa',
    ),
    PropertyItemData(
      id: 10,
      image: 'assets/apartment1.jpg',
      isVideo: true,
      aspectRatio: 1.1,
      type: 'Apartment',
    ),
    PropertyItemData(
      id: 11,
      image: 'assets/building.jpg',
      isVideo: true,
      aspectRatio: 1.3,
      type: 'House',
    ),
  ];

  List<String> suggestions = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        showSuggestions = false;
      });
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text;

    if (query.isEmpty) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
      return;
    }

    // Generate suggestions based on property types
    Set<String> suggestionSet = {};
    List<String> propertyTypes = ['Apartment', 'Villa', 'Building', 'House'];
    
    for (var type in propertyTypes) {
      if (type.toLowerCase().contains(query.toLowerCase())) {
        suggestionSet.add(type);
      }
    }

    setState(() {
      suggestions = suggestionSet.toList();
      showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;

    // Navigate to SearchScreen with the search query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Searchpage(searchQuery: query),
      ),
    );
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search Apartment, Villa, Building, House',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue[400],
                      size: 28,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[400]),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  onSubmitted: _performSearch,
                ),
              ),
            ),

            // Suggestions Dropdown
            if (showSuggestions && suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.blue[400],
                      ),
                      title: Text(
                        suggestions[index],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => _selectSuggestion(suggestions[index]),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                    );
                  },
                ),
              ),

            if (showSuggestions && suggestions.isNotEmpty)
              const SizedBox(height: 16),

            // Shuffled Property Grid - Images Only
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: const EdgeInsets.all(8),
                itemCount: allProperties.length,
                itemBuilder: (context, index) {
                  return PropertyImageCard(property: allProperties[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyItemData {
  final int id;
  final String image;
  final bool isVideo;
  final double aspectRatio;
  final String type;

  PropertyItemData({
    required this.id,
    required this.image,
    required this.isVideo,
    required this.aspectRatio,
    required this.type,
  });
}

class PropertyImageCard extends StatelessWidget { 
  final PropertyItemData property;

  const PropertyImageCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to search page with property type
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Searchpage(searchQuery: property.type),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              AspectRatio(
                aspectRatio: property.aspectRatio,
                child: Image.asset(
                  property.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.home,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              if (property.isVideo)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
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