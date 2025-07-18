class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;
  final Map<String, dynamic>? pagination;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['status'] == 'success',
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error'],
      pagination: json['pagination'],
    );
  }

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(
      success: true,
      message: message ?? 'Success',
      data: data,
    );
  }

  factory ApiResponse.error(String message, {String? error}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      error: error,
    );
  }
}
