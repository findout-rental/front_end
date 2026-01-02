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
}
