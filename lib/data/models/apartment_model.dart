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
