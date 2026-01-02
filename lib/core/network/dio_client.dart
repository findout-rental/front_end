import 'package:dio/dio.dart';
import 'package:project/core/storage/auth_storage.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthStorage().token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        onError: (DioException e, handler) {
  print('--- DIO ERROR ---');
  print('type: ${e.type}');
  print('status: ${e.response?.statusCode}');
  print('data: ${e.response?.data}');

  final responseData = e.response?.data;

  final String message =
      (responseData is Map && responseData['message'] != null)
          ? responseData['message'].toString()
          : 'Unexpected error occurred';

  final ApiErrorType type;
  switch (e.response?.statusCode) {
    case 401:
      type = ApiErrorType.unauthorized;
      break;
    case 403:
      type = ApiErrorType.forbidden;
      break;
    case 422:
      type = ApiErrorType.validation;
      break;
    case 500:
      type = ApiErrorType.server;
      break;
    default:
      type = ApiErrorType.unknown;
  }

  final apiException = ApiException(
    message: message,
    type: type,
    statusCode: e.response?.statusCode,
  );

  // 🔥 المهم هنا
  handler.reject(
    DioException(
      requestOptions: e.requestOptions,
      error: apiException, // 👈 نضع ApiException هنا
      response: e.response,
      type: e.type,
    ),
  );
},

      ),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
    );
  }
}
