import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../../shared/models/api_response.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  String? _authToken;

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token
  void clearAuthToken() {
    _authToken = null;
  }

  // Get headers for requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = json.decode(response.body) as Map<String, dynamic>;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw ApiException(
        message: body['message'] ?? 'Unknown error occurred',
        statusCode: response.statusCode,
        error: body['error'],
      );
    }
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final uriWithQuery = queryParameters != null
          ? uri.replace(queryParameters: queryParameters)
          : uri;

      final response = await _client.get(uriWithQuery, headers: _headers);
      final responseData = _handleResponse(response);
      
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client.post(
        uri,
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      
      final responseData = _handleResponse(response);
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client.put(
        uri,
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      
      final responseData = _handleResponse(response);
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
      final response = await _client.delete(uri, headers: _headers);
      
      final responseData = _handleResponse(response);
      return ApiResponse.fromJson(responseData, fromJson);
    } catch (e) {
      rethrow;
    }
  }

  // Dispose the client
  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String? error;

  ApiException({
    required this.message,
    required this.statusCode,
    this.error,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }
}