import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

        listFormat: ListFormat.multiCompatible,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AuthStorage().token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            final safeHeaders = _maskAuthHeader(options.headers);
            debugPrint('--- DIO REQUEST ---');
            debugPrint('url: ${options.baseUrl}${options.path}');
            debugPrint('method: ${options.method}');
            debugPrint('headers: $safeHeaders');
            debugPrint('query: ${options.queryParameters}');
            debugPrint('data: ${options.data}');
            debugPrint('-------------------');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('--- DIO RESPONSE ---');
            debugPrint(
              'url: ${response.requestOptions.baseUrl}${response.requestOptions.path}',
            );
            debugPrint('status: ${response.statusCode}');
            debugPrint('headers: ${response.headers.map}');
            debugPrint('data: ${response.data}');
            debugPrint('--------------------');
          }

          handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            final safeHeaders = _maskAuthHeader(e.requestOptions.headers);
            debugPrint('--- DIO ERROR ---');
            debugPrint('type: ${e.type}');
            debugPrint(
              'url: ${e.requestOptions.baseUrl}${e.requestOptions.path}',
            );
            debugPrint('method: ${e.requestOptions.method}');
            debugPrint('headers: $safeHeaders');
            debugPrint('query: ${e.requestOptions.queryParameters}');
            debugPrint('request data: ${e.requestOptions.data}');
            debugPrint('status: ${e.response?.statusCode}');
            debugPrint('response headers: ${e.response?.headers.map}');
            debugPrint('response data: ${e.response?.data}');
            debugPrint('---------------');
          }

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

  Map<String, dynamic> _maskAuthHeader(Map headers) {
    final safe = <String, dynamic>{};
    headers.forEach((key, value) {
      final k = key.toString();
      if (k.toLowerCase() == 'authorization') {
        safe[k] = 'Bearer ***';
      } else {
        safe[k] = value;
      }
    });
    return safe;
  }

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
