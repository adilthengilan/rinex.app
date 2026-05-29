import 'package:cloud_firestore/cloud_firestore.dart';

/// Mirrors the Firestore document structure exactly.
class PropertyModel {
  final String title;
  final String description;
  final double price;
  final String currency;
  final String type; // villa / house / apartment / condo / office
  final String purpose; // sale / rent
  final int bedrooms;
  final int bathrooms;
  final int kitchen;
  final int parking;
  final double area;
  final String furnishing; // Furnished / Semi-Furnished / Unfurnished
  final int yearBuilt;
  final String address;
  final String city;
  final String country;
  final PropertyLocation location;
  final List<String> images;
  final List<String> videos;
  final String? audioUrl;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final String status; // active / pending / sold
  final int views;
  final int likes;
  final int shares;
  final bool featured;
  final bool legalClearance;
  final bool loanAvailable;
  final List<String> tags;
  final String? additionalInfo;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const PropertyModel({
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'AED',
    required this.type,
    this.purpose = 'sale',
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchen,
    required this.parking,
    required this.area,
    required this.furnishing,
    required this.yearBuilt,
    required this.address,
    required this.city,
    required this.country,
    required this.location,
    required this.images,
    required this.videos,
    this.audioUrl,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    this.status = 'active',
    this.views = 0,
    this.likes = 0,
    this.shares = 0,
    this.featured = false,
    this.legalClearance = false,
    this.loanAvailable = false,
    this.tags = const [],
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'price': price,
    'currency': currency,
    'type': type,
    'purpose': purpose,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'kitchen': kitchen,
    'parking': parking,
    'area': area,
    'furnishing': furnishing,
    'yearBuilt': yearBuilt,
    'address': address,
    'city': city,
    'country': country,
    'location': location.toMap(),
    'images': images,
    'videos': videos,
    'audioUrl': audioUrl,
    'ownerId': ownerId,
    'ownerName': ownerName,
    'ownerPhone': ownerPhone,
    'ownerEmail': ownerEmail,
    'status': status,
    'views': views,
    'likes': likes,
    'shares': shares,
    'featured': featured,
    'legalClearance': legalClearance,
    'loanAvailable': loanAvailable,
    'tags': tags,
    'additionalInfo': additionalInfo,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class PropertyLocation {
  final GeoPoint geopoint;
  final double lat;
  final double lng;

  const PropertyLocation({
    required this.geopoint,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {
    'geopoint': geopoint,
    'lat': lat,
    'lng': lng,
  };
}
