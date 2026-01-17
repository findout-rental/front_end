enum ApiErrorType {
  network,
  timeout,
  validation,
  unauthorized,
  forbidden,
  server,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;
  final int? statusCode;

  ApiException({required this.message, required this.type, this.statusCode});

  @override
  String toString() => message;
}
