import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  String? _userRole;
  Outlet? _selectedOutlet;
  bool _isLoading = false;

  // Getters
  User? get currentUser => _currentUser;
  String? get userRole => _userRole;
  Outlet? get selectedOutlet => _selectedOutlet;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null && _userRole != null;

  // Initialize auth state from storage
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString(AppConstants.storageKeyRole);
      
      if (role != null) {
        _userRole = role;
        
        // Create a mock user for demo purposes
        // In a real app, you would retrieve actual user data
        _currentUser = User(
          userId: 1,
          name: role == AppConstants.roleKasir ? 'Kasir Demo' : 'Mekanik Demo',
          email: '$role@demo.com',
          outletId: 1,
          outlet: Outlet(
            outletId: 1,
            outletName: 'Workshop Demo',
            branchType: 'Pusat',
            city: 'Jakarta',
            address: 'Jl. Demo No. 123',
            phoneNumber: '021-12345678',
            status: 'Aktif',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        _selectedOutlet = _currentUser!.outlet;
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select role and simulate login
  Future<void> selectRole(String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Store role in preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.storageKeyRole, role);

      _userRole = role;
      
      // Create mock user based on role
      _currentUser = User(
        userId: role == AppConstants.roleKasir ? 1 : 2,
        name: role == AppConstants.roleKasir ? 'Kasir Demo' : 'Mekanik Demo',
        email: '$role@demo.com',
        outletId: 1,
        outlet: Outlet(
          outletId: 1,
          outletName: 'Workshop Demo',
          branchType: 'Pusat',
          city: 'Jakarta',
          address: 'Jl. Demo No. 123',
          phoneNumber: '021-12345678',
          status: 'Aktif',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _selectedOutlet = _currentUser!.outlet;
    } catch (e) {
      debugPrint('Error selecting role: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Clear stored data
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _currentUser = null;
      _userRole = null;
      _selectedOutlet = null;
    } catch (e) {
      debugPrint('Error logging out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Switch outlet (for demo purposes)
  Future<void> selectOutlet(Outlet outlet) async {
    _selectedOutlet = outlet;
    
    // Store outlet info
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.storageKeyOutlet, outlet.outletName);
    
    notifyListeners();
  }
}