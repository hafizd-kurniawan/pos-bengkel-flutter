class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final String? error;
  final Pagination? pagination;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.error,
    this.pagination,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    T? data;
    if (json['data'] != null && fromJsonT != null) {
      if (json['data'] is List) {
        // Handle list data
        data = (json['data'] as List)
            .map((item) => fromJsonT(item as Map<String, dynamic>))
            .toList() as T;
      } else if (json['data'] is Map<String, dynamic>) {
        // Handle single object data
        data = fromJsonT(json['data'] as Map<String, dynamic>);
      }
    } else {
      data = json['data'] as T?;
    }

    return ApiResponse<T>(
      status: json['status'],
      message: json['message'],
      data: data,
      error: json['error'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      pages: json['pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }

  bool get hasNextPage => page < pages;
  bool get hasPreviousPage => page > 1;
}