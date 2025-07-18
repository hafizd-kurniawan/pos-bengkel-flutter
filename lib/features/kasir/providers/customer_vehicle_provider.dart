import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/core/repositories/customer_vehicle_repository.dart';
import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class CustomerVehicleProvider extends ChangeNotifier {
  final CustomerVehicleRepository _repository;

  List<CustomerVehicle> _vehicles = [];
  List<CustomerVehicle> _searchResults = [];
  List<CustomerVehicle> _customerVehicles = [];
  CustomerVehicle? _selectedVehicle;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<CustomerVehicle> get vehicles => _vehicles;
  List<CustomerVehicle> get searchResults => _searchResults;
  List<CustomerVehicle> get customerVehicles => _customerVehicles;
  CustomerVehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  CustomerVehicleProvider({CustomerVehicleRepository? repository})
      : _repository = repository ?? CustomerVehicleRepository();

  Future<void> loadVehicles({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      if (page == 1) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
      }

      final response = await _repository.getCustomerVehicles(
        page: page,
        limit: limit,
        search: search,
      );

      if (response.success) {
        if (page == 1) {
          _vehicles = response.data ?? [];
        } else {
          _vehicles.addAll(response.data ?? []);
        }
        _errorMessage = null;
        debugPrint('✅ Loaded ${_vehicles.length} vehicles');
      } else {
        _errorMessage = response.message;
        debugPrint('❌ Failed to load vehicles: ${response.message}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error loading vehicles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadVehiclesByCustomerId(String customerId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _customerVehicles = []; // Clear previous data
      notifyListeners();

      print('🚗 [Provider] Loading vehicles for customer ID: $customerId');

      final response = await _repository.getVehiclesByCustomerId(customerId);

      print('📦 [Provider] Repository response: success=${response.success}');
      print('📦 [Provider] Data count: ${response.data?.length ?? 0}');

      if (response.data != null && response.data!.isNotEmpty) {
        for (var vehicle in response.data!) {
          print('🚗 [Provider] Vehicle: ${vehicle.displayName}');
        }
      }

      if (response.success) {
        _customerVehicles = response.data ?? [];
        _errorMessage = null;
        print(
            '✅ [Provider] Successfully loaded ${_customerVehicles.length} vehicles for customer $customerId');
      } else {
        _errorMessage = response.message;
        _customerVehicles = [];
        print(
            '❌ [Provider] Failed to load customer vehicles: ${response.message}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _customerVehicles = [];
      print('❌ [Provider] Error loading customer vehicles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      print(
          '🔄 [Provider] Final state: isLoading=$_isLoading, vehicleCount=${_customerVehicles.length}');
    }
  }

  Future<bool> createVehicle(CustomerVehicle vehicle) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      debugPrint('🚗 Creating vehicle: ${vehicle.displayName}');

      final response = await _repository.createCustomerVehicle(vehicle);

      if (response.success) {
        _vehicles.insert(0, response.data!);
        _customerVehicles.insert(0, response.data!);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        debugPrint(
            '✅ Vehicle created successfully: ${response.data!.displayName}');
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        debugPrint('❌ Failed to create vehicle: ${response.message}');
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error creating vehicle: $e');
      return false;
    }
  }

  Future<void> searchVehicles(String query) async {
    try {
      _searchQuery = query;
      _isSearching = true;
      _errorMessage = null;
      notifyListeners();

      if (query.isEmpty) {
        _searchResults = [];
        _isSearching = false;
        notifyListeners();
        return;
      }

      final response = await _repository.searchCustomerVehicles(query);

      if (response.success) {
        _searchResults = response.data ?? [];
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
        _searchResults = [];
      }
    } catch (e) {
      _errorMessage = e.toString();
      _searchResults = [];
      debugPrint('Error searching vehicles: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void selectVehicle(CustomerVehicle? vehicle) {
    _selectedVehicle = vehicle;
    debugPrint('🎯 Selected vehicle: ${vehicle?.displayName ?? 'None'}');
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
