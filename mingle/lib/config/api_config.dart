/// API Configuration
/// Store all API endpoints and base URLs here
class ApiConfig {
  // Base URL for your API
  static const String baseUrl = 'https://fintechsummit2026-rqxl.onrender.com';

  // Auth endpoints
  static const String loginEndpoint = '/user/login';
  static const String registerEndpoint = '/user/register';
  static const String logoutEndpoint = '/auth/logout';

  // Restaurant endpoints

  // User endpoints
  static const String getUserProfile = '/user/profile';
  static const String updateUserProfile = '/user/update';

  // Get full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
}