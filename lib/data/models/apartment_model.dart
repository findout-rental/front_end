import 'package:project/core/network/api_endpoints.dart';

class Apartment {
  final String id;

  // UI fields (قديمة بس نولّدها من بيانات الباك)
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

  // ✅ حقول جديدة مفيدة (اختياري لكن أنصح فيها)
  final String governorate;
  final String city;
  final String address;
  final double nightlyPrice;
  final double monthlyPrice;
  final List<String> amenities;

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
    this.reviewCount = 80,
    required this.pricePerNight,

    required this.governorate,
    required this.city,
    required this.address,
    required this.nightlyPrice,
    required this.monthlyPrice,
    required this.amenities,
  });

  static String _resolveUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    // baseUrl عندك غالبًا ينتهي بـ /api، صور Laravel تكون خارج /api
    final base = ApiEndpoints.baseUrl.replaceAll(RegExp(r'/api/?$'), '');
    if (path.startsWith('/')) return '$base$path';
    return '$base/$path';
  }

  factory Apartment.fromJson(Map<String, dynamic> json) {
    final String city = (json['city'] ?? '').toString();
    final String governorate = (json['governorate'] ?? '').toString();
    final String address = (json['address'] ?? '').toString();

    final List<dynamic> photosRaw = (json['photos'] as List?) ?? [];
    final List<String> photos = photosRaw.map((e) => _resolveUrl(e.toString())).toList();

    final double nightly = double.tryParse((json['nightly_price'] ?? '0').toString()) ?? 0;
    final double monthly = double.tryParse((json['monthly_price'] ?? '0').toString()) ?? 0;

    final List<dynamic> amenitiesRaw = (json['amenities'] as List?) ?? [];
    final List<String> amenities = amenitiesRaw.map((e) => e.toString()).toList();

    final location = [
      address,
      city,
      governorate,
    ].where((e) => e.trim().isNotEmpty).join(', ');

    return Apartment(
      id: (json['id'] ?? '').toString(),

      imageUrl: photos.isNotEmpty ? photos.first : '',
      images: photos,

      title: json['title']?.toString().isNotEmpty == true
          ? json['title'].toString()
          : 'شقة في $city',

      location: location,
      price: nightly > 0 ? nightly.toString() : (monthly > 0 ? monthly.toString() : '0'),

      // favorites إذا عندك endpoint منفصل، خليه false وبيتم ضبطه بالكونترولر
      isFavorited: (json['is_favorited'] ?? false) == true,

      isAvailable: (json['is_available'] ?? true) == true,

      rating: double.tryParse((json['rating'] ?? '4.5').toString()) ?? 4.5,
      reviewCount: int.tryParse((json['review_count'] ?? '0').toString()) ?? 0,

      pricePerNight: nightly.toInt(),

      governorate: governorate,
      city: city,
      address: address,
      nightlyPrice: nightly,
      monthlyPrice: monthly,
      amenities: amenities,
    );
  }
}
