class Apartment {
  final String id;
  final String imageUrl;
  final String title;
  final String location;
  final String price;

  /// UI state (can change locally)
  bool isFavorited;

  /// Gallery images
  final List<String> images;

  /// Availability status
  final bool isAvailable;

  /// Rating info
  final double rating;
  final int reviewCount;

  /// Business logic (booking)
  final int pricePerNight;

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
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
  final String city = json['city'] ?? '';
  final String governorate = json['governorate'] ?? '';
  final String address = json['address'] ?? '';

  final List imagesList = json['images'] ?? [];

  return Apartment(
    id: json['id']?.toString() ?? '',

    // ✅ أول صورة أو placeholder
    imageUrl: imagesList.isNotEmpty
        ? imagesList.first.toString()
        : '',

    // ✅ عنوان منطقي
    title: json['title'] ??
        'Apartment in $city',

    // ✅ دمج الموقع بدل location الوهمي
    location: [
      address,
      city,
      governorate,
    ].where((e) => e.isNotEmpty).join(', '),

    // ✅ السعر للـ UI (string)
    price: json['price_per_night'] != null
        ? '${json['price_per_night']}'
        : '0',

    isFavorited: json['is_favorited'] ?? false,

    images: imagesList.map((e) => e.toString()).toList(),

    isAvailable: json['is_available'] ?? true,

    rating: json['rating'] != null
        ? double.tryParse(json['rating'].toString()) ?? 4.5
        : 4.5,

    reviewCount: json['review_count'] ?? 0,

    // ✅ business logic
    pricePerNight: json['price_per_night'] ?? 0,
  );
}


  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'title': title,
    'location': location,
    'price': price,
    'is_favorited': isFavorited,
    'images': images,
    'is_available': isAvailable,
    'rating': rating,
    'review_count': reviewCount,
    'price_per_night': pricePerNight,
  };
}
