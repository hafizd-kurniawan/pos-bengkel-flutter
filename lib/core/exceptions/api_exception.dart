class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? error;

  ApiException(this.message, {this.statusCode, this.error});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}
