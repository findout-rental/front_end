import 'package:project/core/network/api_endpoints.dart';

class Apartment {
  final String id;
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  bool isFavorited;
  final List<String> images;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final int pricePerNight;
  final double nightlyPrice;
  final double monthlyPrice;
  final String governorate;
  final String city;
  final String address;
  final String description;
  final int bedrooms;
  final int bathrooms;
  final double size;
  final int livingRooms;
  final int maxGuests;
  final List<String> amenities;
  final String? ownerId;
  final String? ownerName;
  final String? ownerImageUrl;

  Apartment({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    this.isFavorited = false,
    required this.images,
    this.isAvailable = true,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.pricePerNight = 0,
    this.governorate = '',
    this.city = '',
    this.address = '',
    this.nightlyPrice = 0,
    this.monthlyPrice = 0,
    this.amenities = const [],

    this.description = '',
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.size = 0,
    this.livingRooms = 0,
    this.maxGuests = 0,

    this.ownerId,
    this.ownerName,
    this.ownerImageUrl,
  });


  static String _resolveUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    final base = ApiEndpoints.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (path.startsWith('/')) return '$base$path';
    return '$base/$path';
  }

  static double _asDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _asString(dynamic v) => (v ?? '').toString();

  bool get hasBalcony {
    final a = amenities.map((e) => e.toLowerCase().trim()).toList();
    return a.contains('balcony') || a.any((x) => x.contains('شرفة'));
  }

  bool get hasWifi {
    final a = amenities.map((e) => e.toLowerCase().trim()).toList();
    return a.contains('wifi') || a.contains('wi-fi') || a.any((x) => x.contains('انترنت'));
  }

  bool get hasAc {
    final a = amenities.map((e) => e.toLowerCase().trim()).toList();
    return a.contains('air conditioning') || a.contains('ac') || a.any((x) => x.contains('تكييف'));
  }

  factory Apartment.fromJson(Map<String, dynamic> json) {
    final List<dynamic> photosRaw = (json['photos'] as List?) ?? (json['images'] as List?) ?? [];
    final List<String> photos = photosRaw.map((e) => _resolveUrl(e.toString())).toList();

    final double nightly = _asDouble(
      json['nightly_price'] ??
          json['price_per_night'] ??
          json['pricePerNight'] ??
          json['night_price'],
    );

    final double monthly = _asDouble(
      json['monthly_price'] ?? json['price_per_month'] ?? json['monthlyPrice'],
    );

    final bedrooms = _asInt(json['bedrooms']);
    final bathrooms = _asInt(json['bathrooms']);
    final livingRooms = _asInt(json['living_rooms'] ?? json['livingRooms']);
    final maxGuests = _asInt(json['max_guests'] ?? json['maxGuests']);
    final size = _asDouble(json['size'] ?? json['area'] ?? json['square_meters']);

    final description = _asString(json['description']);

    final String city = _asString(json['city']);
    final String governorate = _asString(json['governorate']);
    final String address = _asString(json['address']);

    final location = [address, city, governorate].where((e) => e.trim().isNotEmpty).join(', ');

    final List<dynamic> amenitiesRaw = (json['amenities'] as List?) ?? [];
    final List<String> amenities = amenitiesRaw.map((e) => e.toString()).toList();

    String? ownerId;
    String? ownerName;
    String? ownerImage;

    final ownerRaw = json['owner'] ?? json['user'] ?? json['owner_user'];
    if (ownerRaw is Map) {
      final m = Map<String, dynamic>.from(ownerRaw);
      ownerId = (m['id'] ?? m['uid'])?.toString();

      final first = (m['first_name'] ?? '').toString().trim();
      final last = (m['last_name'] ?? '').toString().trim();
      final full = (m['full_name'] ?? m['name'] ?? '').toString().trim();
      ownerName = full.isNotEmpty ? full : ('$first $last').trim();

      ownerImage = (m['profile_image_url'] ?? m['personal_photo'] ?? m['avatar'])?.toString();
      if (ownerImage != null && ownerImage.isNotEmpty) {
        ownerImage = _resolveUrl(ownerImage);
      }
    }

    final title = (json['title']?.toString().trim().isNotEmpty == true)
        ? json['title'].toString()
        : (city.isNotEmpty ? 'Apartment in $city' : 'Apartment');

    final priceString = nightly > 0
        ? nightly.toString()
        : (monthly > 0 ? monthly.toString() : '0');

    return Apartment(
      id: (json['id'] ?? '').toString(),
      imageUrl: photos.isNotEmpty ? photos.first : '',
      images: photos,
      title: title,
      location: location,
      price: priceString,

      isFavorited: (json['is_favorited'] ?? false) == true,
      isAvailable: (json['is_available'] ?? true) == true,

      rating: _asDouble(json['rating'] ?? 0),
      reviewCount: _asInt(json['review_count'] ?? json['reviews_count'] ?? 0),

      pricePerNight: nightly.toInt(),
      nightlyPrice: nightly,
      monthlyPrice: monthly,

      governorate: governorate,
      city: city,
      address: address,

      description: description,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      size: size,
      livingRooms: livingRooms,
      maxGuests: maxGuests,

      amenities: amenities,

      ownerId: ownerId,
      ownerName: ownerName,
      ownerImageUrl: ownerImage,
    );
  }
}
