// lib/services/apartment_service.dart

import 'package:dio/dio.dart';
import 'package:project/core/network/dio_client.dart';
import 'package:project/core/network/api_endpoints.dart';

class ApartmentService {
  final DioClient _dioClient;
  ApartmentService(this._dioClient);

  // =========================
  // TENANT: Get apartments list (public/tenant)
  // =========================
  Future<Response> getApartments({Map<String, dynamic>? filters}) {
    return _dioClient.get(
      ApiEndpoints.apartments, // ✅ /apartments
      queryParameters: filters,
    );
  }

  // =========================
  // OWNER: Get my apartments list
  // =========================
  Future<Response> getOwnerApartments({Map<String, dynamic>? filters}) {
    return _dioClient.get(
      ApiEndpoints.ownerApartments, // ✅ /owner/apartments
      queryParameters: filters,
    );
  }

  // =========================
  // OWNER: Add apartment
  // =========================
  Future<Response> addApartment(FormData formData) {
    return _dioClient.post(
      ApiEndpoints.ownerApartments, // ✅ /owner/apartments
      data: formData,
    );
  }

  // =========================
  // TENANT: Apartment details
  // =========================
  Future<Response> getApartmentDetails(String apartmentId) {
    return _dioClient.get(
      '${ApiEndpoints.apartments}/$apartmentId', // ✅ /apartments/{id}
    );
  }

  // =========================
  // OWNER: My apartment details (إذا عندك endpoint خاص بالمالك)
  // ملاحظة: إذا الباك عنده /owner/apartments/{id}
  // =========================
  Future<Response> getOwnerApartmentDetails(String apartmentId) {
    return _dioClient.get(
      '${ApiEndpoints.ownerApartments}/$apartmentId', // ✅ /owner/apartments/{id}
    );
  }
}
