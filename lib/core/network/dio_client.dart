import 'package:dio/dio.dart';
import 'package:project/core/network/api_endpoints.dart';
import 'package:project/core/network/api_exceptions.dart';
import 'package:project/core/storage/auth_storage.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        headers: {'Accept': 'application/json'},
      ),
    );

    // Log Interceptor
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Auth + Error Interceptor
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

          // 🔥 نمرر ApiException بدل DioException عادي
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: apiException,
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  Dio get dio => _dio;

  // ================= REQUEST METHODS =================

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
