import 'package:flutter/material.dart';

class PropertySearchPage extends StatefulWidget {
  const PropertySearchPage({super.key});

  @override
  State<PropertySearchPage> createState() => _PropertySearchPageState();
}

class _PropertySearchPageState extends State<PropertySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Property> allProperties = [
    Property(
      id: 1,
      name: 'Luxury Villa',
      location: 'Mumbai',
      price: 50000000,
      type: 'Villa',
    ),
    Property(
      id: 2,
      name: 'Modern Apartment',
      location: 'Delhi',
      price: 8000000,
      type: 'Apartment',
    ),
    Property(
      id: 3,
      name: 'Beach House',
      location: 'Goa',
      price: 35000000,
      type: 'House',
    ),
    Property(
      id: 4,
      name: 'Penthouse Suite',
      location: 'Bangalore',
      price: 15000000,
      type: 'Penthouse',
    ),
    Property(
      id: 5,
      name: 'Studio Flat',
      location: 'Mumbai',
      price: 4500000,
      type: 'Studio',
    ),
    Property(
      id: 6,
      name: 'Garden Villa',
      location: 'Pune',
      price: 25000000,
      type: 'Villa',
    ),
    Property(
      id: 7,
      name: 'City Apartment',
      location: 'Chennai',
      price: 6000000,
      type: 'Apartment',
    ),
  ];

  List<Property> filteredProperties = [];
  List<String> suggestions = [];
  bool showSuggestions = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredProperties = allProperties;
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
        filteredProperties = allProperties;
        isSearching = false;
      });
      return;
    }

    Set<String> suggestionSet = {};
    for (var property in allProperties) {
      if (property.name.toLowerCase().contains(query.toLowerCase())) {
        suggestionSet.add(property.name);
      }
      if (property.location.toLowerCase().contains(query.toLowerCase())) {
        suggestionSet.add(property.location);
      }
      if (property.type.toLowerCase().contains(query.toLowerCase())) {
        suggestionSet.add(property.type);
      }
    }

    setState(() {
      suggestions = suggestionSet.take(5).toList();
      showSuggestions = suggestions.isNotEmpty;
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProperties = allProperties;
        isSearching = false;
        showSuggestions = false;
      });
      return;
    }

    setState(() {
      filteredProperties = allProperties.where((property) {
        return property.name.toLowerCase().contains(query.toLowerCase()) ||
            property.location.toLowerCase().contains(query.toLowerCase()) ||
            property.type.toLowerCase().contains(query.toLowerCase());
      }).toList();
      isSearching = true;
      showSuggestions = false;
    });
    _searchFocusNode.unfocus();
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
      extendBody: true,
      appBar: AppBar(
        title: const Text('Property Search'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search by name, location, or type...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSubmitted: _performSearch,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _performSearch(_searchController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Search Properties'),
                ),
              ],
            ),
          ),

          // Suggestions Dropdown
          if (showSuggestions && suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.search, size: 20),
                    title: Text(suggestions[index]),
                    onTap: () => _selectSuggestion(suggestions[index]),
                    dense: true,
                  );
                },
              ),
            ),

          // Results Section
          Expanded(
            child: filteredProperties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isSearching
                              ? 'No properties found'
                              : 'Start searching for properties',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProperties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(property: filteredProperties[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle property tap
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Selected: ${property.name}')));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.home, size: 40, color: Colors.blue[700]),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property.location,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            property.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${(property.price / 10000000).toStringAsFixed(2)} Cr',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Property {
  final int id;
  final String name;
  final String location;
  final double price;
  final String type;

  Property({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.type,
  });
}
