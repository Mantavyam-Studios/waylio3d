/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Waylio';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'AR Indoor Navigation';
  
  // Building Info
  static const String buildingName = 'USB Building';
  static const String buildingFloor = 'Ground Floor';
  static const String buildingLocation = 'Chandigarh University';
  
  // Multiset SDK Configuration
  static const String multisetMapId = 'MSET_Z1RHU09TW3AX';
  static const String multisetClientId = '2851ecaf-7363-4c0f-aff5-47b4a3e7ecd9';
  static const String multisetClientSecret = 'dd150f0bfa92d8af9e0649382d45841d5f8d458903b3d75a7c7ee3cdaf3b35f1';
  static const String multisetAuthUrl = 'https://api.multiset.ai/v1/m2m/token';
  static const String multisetQueryUrl = 'https://api.multiset.ai/v1/vps/map/query-form';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String favoritesCollection = 'favorites';
  static const String historyCollection = 'navigation_history';
  
  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserType = 'user_type';
  static const String keyIsGuestMode = 'is_guest_mode';
  static const String keyThemeMode = 'theme_mode';
  
  // User Types
  static const List<String> userTypes = [
    'Student',
    'Visitor',
    'Faculty',
    'Public',
  ];
  
  // Destination Categories
  static const List<String> destinationCategories = [
    'Classroom',
    'Laboratory',
    'Office',
    'Facility',
  ];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxFeedbackLength = 500;
  static const int maxRecentDestinations = 5;
  static const int maxHistoryItems = 50;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // API Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration localizationTimeout = Duration(seconds: 60);
}

