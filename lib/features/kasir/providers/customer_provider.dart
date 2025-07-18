import 'package:flutter/foundation.dart';
import '../../../core/api/customer_repository.dart';
import '../../../shared/models/customer.dart';
import '../../../shared/models/api_response.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _customerRepository = CustomerRepository();
  final CustomerVehicleRepository _vehicleRepository = CustomerVehicleRepository();

  List<Customer> _customers = [];
  List<CustomerVehicle> _vehicles = [];
  Customer? _selectedCustomer;
  CustomerVehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Customer> get customers => _customers;
  List<CustomerVehicle> get vehicles => _vehicles;
  Customer? get selectedCustomer => _selectedCustomer;
  CustomerVehicle? get selectedVehicle => _selectedVehicle;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Load customers
  Future<void> loadCustomers({int page = 1, int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _customerRepository.getCustomers(
        page: page,
        limit: limit,
      );

      if (response.data != null) {
        if (page == 1) {
          _customers = response.data!;
        } else {
          _customers.addAll(response.data!);
        }
      }
    } catch (e) {
      _setError('Gagal memuat data pelanggan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search customers
  Future<void> searchCustomers(String query) async {
    if (query.isEmpty) {
      await loadCustomers();
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      final response = await _customerRepository.searchCustomers(query: query);

      if (response.data != null) {
        _customers = response.data!;
      }
    } catch (e) {
      _setError('Gagal mencari pelanggan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create customer
  Future<bool> createCustomer({
    required String name,
    required String phoneNumber,
    String? address,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _customerRepository.createCustomer(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
      );

      if (response.data != null) {
        _customers.insert(0, response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal membuat pelanggan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update customer
  Future<bool> updateCustomer(
    int id, {
    String? name,
    String? address,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _customerRepository.updateCustomer(
        id,
        name: name,
        address: address,
      );

      if (response.data != null) {
        final index = _customers.indexWhere((c) => c.customerId == id);
        if (index != -1) {
          _customers[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui pelanggan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get customer by phone
  Future<Customer?> getCustomerByPhone(String phoneNumber) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _customerRepository.getCustomerByPhone(phoneNumber);
      return response.data;
    } catch (e) {
      _setError('Gagal mencari pelanggan berdasarkan nomor telepon: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Select customer
  void selectCustomer(Customer customer) {
    _selectedCustomer = customer;
    loadCustomerVehicles(customer.customerId);
    notifyListeners();
  }

  // Clear selected customer
  void clearSelectedCustomer() {
    _selectedCustomer = null;
    _selectedVehicle = null;
    _vehicles.clear();
    notifyListeners();
  }

  // Load customer vehicles
  Future<void> loadCustomerVehicles(int customerId) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _vehicleRepository.getCustomerVehiclesByCustomer(customerId);

      if (response.data != null) {
        _vehicles = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat data kendaraan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create customer vehicle
  Future<bool> createCustomerVehicle({
    required int customerId,
    required String plateNumber,
    required String brand,
    required String model,
    required String type,
    required int productionYear,
    required String chassisNumber,
    required String engineNumber,
    required String color,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _vehicleRepository.createCustomerVehicle(
        customerId: customerId,
        plateNumber: plateNumber,
        brand: brand,
        model: model,
        type: type,
        productionYear: productionYear,
        chassisNumber: chassisNumber,
        engineNumber: engineNumber,
        color: color,
        notes: notes,
      );

      if (response.data != null) {
        _vehicles.insert(0, response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal membuat kendaraan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update customer vehicle
  Future<bool> updateCustomerVehicle(
    int id, {
    String? model,
    String? color,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _vehicleRepository.updateCustomerVehicle(
        id,
        model: model,
        color: color,
        notes: notes,
      );

      if (response.data != null) {
        final index = _vehicles.indexWhere((v) => v.vehicleId == id);
        if (index != -1) {
          _vehicles[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui kendaraan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select vehicle
  void selectVehicle(CustomerVehicle vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  // Clear selected vehicle
  void clearSelectedVehicle() {
    _selectedVehicle = null;
    notifyListeners();
  }
}