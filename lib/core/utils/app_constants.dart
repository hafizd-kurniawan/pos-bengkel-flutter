class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  // App Information
  static const String appName = 'POS Bengkel';
  static const String appVersion = '1.0.0';

  // Transaction Status
  static const String statusPaid = 'paid';
  static const String statusUnpaid = 'unpaid';
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Payment Methods
  static const String paymentCash = 'cash';
  static const String paymentCredit = 'credit';
  static const String paymentTransfer = 'transfer';

  // Default Values
  static const String defaultCustomer = 'Customer Umum';

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Invoice Settings
  static const String invoicePrefix = '';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
