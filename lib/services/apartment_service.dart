import 'package:dio/dio.dart';
import 'package:project/core/network/dio_client.dart';
import 'package:project/core/network/api_endpoints.dart';

class ApartmentService {
  final DioClient _dioClient;
  ApartmentService(this._dioClient);
  Future<Response> getApartments({Map<String, dynamic>? filters}) {
    return _dioClient.get(ApiEndpoints.apartments, queryParameters: filters);
  }

  Future<Response> getOwnerApartments({Map<String, dynamic>? filters}) {
    return _dioClient.get(
      ApiEndpoints.ownerApartments,
      queryParameters: filters,
    );
  }

  Future<Response> addApartment(FormData formData) {
    return _dioClient.post(ApiEndpoints.ownerApartments, data: formData);
  }

  Future<Response> getApartmentDetails(String apartmentId) {
    return _dioClient.get('${ApiEndpoints.apartments}/$apartmentId');
  }

  Future<Response> getOwnerApartmentDetails(String apartmentId) {
    return _dioClient.get('${ApiEndpoints.ownerApartments}/$apartmentId');
  }
}
