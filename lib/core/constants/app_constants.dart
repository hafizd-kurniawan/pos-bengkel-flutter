class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion';
  
  // App Information
  static const String appName = 'POS Bengkel';
  static const String appVersion = '1.0.0';
  
  // User Roles
  static const String roleSuperadmin = 'superadmin';
  static const String roleKasir = 'kasir';
  static const String roleMekanik = 'mekanik';
  
  // Service Job Status
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';
  
  // Transaction Status
  static const String transactionSuccess = 'sukses';
  static const String transactionPending = 'pending';
  static const String transactionFailed = 'failed';
  
  // Cash Flow Types
  static const String cashFlowIncome = 'Pemasukan';
  static const String cashFlowExpense = 'Pengeluaran';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // Storage Keys
  static const String storageKeyAuth = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyRole = 'user_role';
  static const String storageKeyOutlet = 'selected_outlet';
}