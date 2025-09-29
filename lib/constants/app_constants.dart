class AppConstants {
  // App Information
  static const String appName = 'Cooperative Banking';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.cooperativebank.com';
  static const String apiVersion = '/v1';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String themeModeKey = 'theme_mode';
  
  // Transaction Types
  static const String transferType = 'transfer';
  static const String depositType = 'deposit';
  static const String withdrawalType = 'withdrawal';
  static const String paymentType = 'payment';
  
  // Transaction Status
  static const String pendingStatus = 'pending';
  static const String completedStatus = 'completed';
  static const String failedStatus = 'failed';
  static const String cancelledStatus = 'cancelled';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 20;
  static const int minPinLength = 4;
  static const int maxPinLength = 6;
  
  // Limits
  static const double maxTransferAmount = 100000.0;
  static const double minTransferAmount = 1.0;
  static const int maxTransactionHistory = 100;
}
