import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userToken;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userToken => _userToken;
  Map<String, dynamic>? get userData => _userData;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userDataString = prefs.getString('user_data');

      if (token != null && userDataString != null) {
        _userToken = token;
        _isAuthenticated = true;
        // Parse user data if needed
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call - Replace with actual API implementation
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, accept any email/password
      if (email.isNotEmpty && password.isNotEmpty) {
        _userToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
        _userData = {
          'id': 'kasir-001',
          'name': 'Demo Kasir',
          'email': email,
          'role': 'kasir',
        };
        _isAuthenticated = true;

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _userToken!);
        await prefs.setString('user_data', _userData.toString());

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email dan password tidak boleh kosong';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login gagal: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      // Reset state
      _isAuthenticated = false;
      _userToken = null;
      _userData = null;
      _errorMessage = null;
      _isLoading = false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
