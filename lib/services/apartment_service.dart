// lib/services/apartment_service.dart

import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/dio_client.dart';

class ApartmentService {
  final DioClient _dioClient;
  ApartmentService(this._dioClient);

  // ✅ دالة لجلب الشقق مع فلاتر اختيارية
  Future<Response> getApartments({Map<String, dynamic>? filters}) {
    return _dioClient.get(
      // ملاحظة: قد يكون المسار مختلفًا بناءً على دور المستخدم
      // هذا هو مسار المستأجر
      '/apartments',
      queryParameters: filters,
    );
  }

  Future<Response> addApartment(FormData formData) {
    // ✅ استخدم المسار الصحيح للمالك
    return _dioClient.post('/owner/apartments', data: formData);
  }

  // دالة لجلب تفاصيل شقة معينة
  Future<Response> getApartmentDetails(String apartmentId) {
    return _dioClient.get('/apartments/$apartmentId');
  }
}
