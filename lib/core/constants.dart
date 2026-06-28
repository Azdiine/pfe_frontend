// API Constants
class ApiConstants {
  // Appareil physique : utilise l'IP locale de ta machine
  // Émulateur Android : utilise 'http://10.0.2.2:5000'
  static const String baseUrl = 'http://192.168.1.26:5000';
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String userEndpoint = '/user';
  static const String subscriptionsEndpoint = '/subscriptions';
  static const String profileEndpoint = '/profile';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

// App Constants
class AppConstants {
  static const String appName = 'PFE Front';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String themeKey = 'theme_mode';
}

// UI Constants
class UIConstants {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
}

// Validation Constants
class ValidationConstants {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
}
