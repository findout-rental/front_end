// lib/services/favorite_service.dart

import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class FavoriteService {
  final DioClient _dioClient;
  FavoriteService(this._dioClient);

  /// يجلب قائمة IDs الشقق المفضلة للمستخدم الحالي
  Future<Response> getFavoriteApartmentIds() {
    return _dioClient.get(ApiEndpoints.favorites);
  }

  /// يضيف شقة إلى المفضلة
  Future<Response> addToFavorites(String apartmentId) {
    return _dioClient.post(
      ApiEndpoints.favorites,
      data: {'apartment_id': apartmentId},
    );
  }

  /// يزيل شقة من المفضلة
  Future<Response> removeFromFavorites(String apartmentId) {
    // لارافيل تتوقع DELETE /favorites/{apartment_id}
    return _dioClient.delete('${ApiEndpoints.favorites}/$apartmentId');
  }
}
