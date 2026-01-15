import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

      debugPrint('--- DIO REQUEST ---');
      debugPrint('url: ${options.baseUrl}${options.path}');
      debugPrint('method: ${options.method}');
      debugPrint('headers: ${options.headers}');
      debugPrint('query: ${options.queryParameters}');
      debugPrint('data: ${options.data}');
      debugPrint('-------------------');

      handler.next(options);
    },

    onResponse: (response, handler) {
      debugPrint('--- DIO RESPONSE ---');
      debugPrint('url: ${response.requestOptions.baseUrl}${response.requestOptions.path}');
      debugPrint('status: ${response.statusCode}');
      debugPrint('headers: ${response.headers.map}');
      debugPrint('data: ${response.data}');
      debugPrint('--------------------');

      handler.next(response);
    },

    onError: (e, handler) {
      debugPrint('--- DIO ERROR ---');
      debugPrint('type: ${e.type}');
      debugPrint('url: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      debugPrint('method: ${e.requestOptions.method}');
      debugPrint('headers: ${e.requestOptions.headers}');
      debugPrint('query: ${e.requestOptions.queryParameters}');
      debugPrint('request data: ${e.requestOptions.data}');
      debugPrint('status: ${e.response?.statusCode}');
      debugPrint('response headers: ${e.response?.headers.map}');
      debugPrint('response data: ${e.response?.data}');
      debugPrint('---------------');

      // خليك على كود ApiException تبعك بعد هالطباعة…
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
