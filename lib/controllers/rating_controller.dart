import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:project/services/rating_service.dart';

class RatingController extends GetxController {
  final RatingService _service;
  RatingController(this._service);
  final isSubmitting = false.obs;
  final RxSet<String> ratedBookingIds = <String>{}.obs;

  Future<bool> submitRating({
    required String bookingId,
    required int rating,
    String? reviewText,
  }) async {
    if (ratedBookingIds.contains(bookingId)) {
      Get.snackbar('تنبيه', 'تم تقييم هذا الحجز مسبقاً');
      return false;
    }

    try {
      isSubmitting.value = true;

      await _service.createRating(
        bookingId: bookingId,
        rating: rating,
        reviewText: reviewText,
      );

      ratedBookingIds.add(bookingId);

      Get.snackbar(
        'تم',
        'تم حفظ تقييمك (مرة واحدة فقط)',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on dio.DioException catch (e) {
      final data = e.response?.data;
      String msg = 'فشل حفظ التقييم';

      if (data is Map) {
        if (data['message'] != null) msg = data['message'].toString();
      }

      Get.snackbar('خطأ', msg, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (_) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
