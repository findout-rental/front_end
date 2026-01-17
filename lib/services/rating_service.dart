import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class RatingService {
  final DioClient _dioClient;
  RatingService(this._dioClient);

  Future<Response> createRating({
    required String bookingId,
    required int rating,
    String? reviewText,
  }) {
    final bookingIdValue = int.tryParse(bookingId) ?? bookingId;

    return _dioClient.post(
      ApiEndpoints.ratings,
      data: {
        'booking_id': bookingIdValue,
        'rating': rating,
        if (reviewText != null && reviewText.trim().isNotEmpty)
          'review_text': reviewText.trim(),
      },
    );
  }
}
