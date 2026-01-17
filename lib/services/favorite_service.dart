import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class FavoriteService {
  final DioClient _dioClient;
  FavoriteService(this._dioClient);

  Future<Response> getFavoriteApartmentIds() {
    return _dioClient.get(ApiEndpoints.favorites);
  }

  Future<Response> addToFavorites(String apartmentId) {
    return _dioClient.post(
      ApiEndpoints.favorites,
      data: {'apartment_id': apartmentId},
    );
  }

  Future<Response> removeFromFavorites(String apartmentId) {
    return _dioClient.delete('${ApiEndpoints.favorites}/$apartmentId');
  }
}
