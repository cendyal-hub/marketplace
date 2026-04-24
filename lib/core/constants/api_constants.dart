class ApiConstants {
  static const String baseUrl = 'http://Cendys-MacBook-Air.local:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoint
  static const String products = '/products';

  // Timeout
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}