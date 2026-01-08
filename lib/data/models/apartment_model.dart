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
    return Apartment(
      id: json['id'].toString(),
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      price: json['price'].toString(),
      isFavorited: json['is_favorited'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      isAvailable: json['is_available'] ?? true,
      rating: (json['rating'] != null)
          ? double.parse(json['rating'].toString())
          : 4.5,
      reviewCount: json['review_count'] ?? 0,
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
