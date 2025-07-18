import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pos_bengkel/core/utils/app_constants.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? pagination;
  final String? error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
    this.error,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    // Sesuai format response di README.md
    return ApiResponse<T>(
      success: json['status'] == 'success',
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      pagination: json['pagination'],
      error: json['error'],
    );
  }
}

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 REQUEST: ${options.method} ${options.path}');
          print('📝 DATA: ${options.data}');
          print('📊 QUERY: ${options.queryParameters}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          print('📦 DATA: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.requestOptions.path}');
          print('💥 MESSAGE: ${error.message}');
          print('📋 RESPONSE: ${error.response?.data}');
          _handleError(error);
          handler.next(error);
        },
      ),
    );
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiException('Koneksi timeout. Periksa koneksi internet Anda.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ?? 'Terjadi kesalahan pada server';
        throw ApiException('Error $statusCode: $message');
      case DioExceptionType.cancel:
        throw ApiException('Request dibatalkan');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw ApiException(
              'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
        }
        throw ApiException('Terjadi kesalahan yang tidak diketahui');
      default:
        throw ApiException('Terjadi kesalahan yang tidak diketahui');
    }
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>.fromJson(response.data, fromJson);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      throw ApiException('Terjadi kesalahan: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
