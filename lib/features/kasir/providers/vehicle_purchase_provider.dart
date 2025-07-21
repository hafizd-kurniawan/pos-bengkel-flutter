import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';
import 'package:pos_bengkel/shared/models/vehicle_purchase.dart';
import 'package:pos_bengkel/shared/models/vehicle.dart';
import 'package:pos_bengkel/core/services/api_service.dart';

class VehiclePurchaseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Current purchase form data
  Customer? _selectedCustomer;
  CustomerVehicle? _selectedVehicle;
  double _purchasePrice = 0.0;
  String _condition = 'Baik';
  String _notes = '';
  String _nextAction = 'servis';
  String _invoiceNumber = '';

  // Purchase history
  List<VehiclePurchase> _purchases = [];
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Customer? get selectedCustomer => _selectedCustomer;
  CustomerVehicle? get selectedVehicle => _selectedVehicle;
  double get purchasePrice => _purchasePrice;
  String get condition => _condition;
  String get notes => _notes;
  String get nextAction => _nextAction;
  String get invoiceNumber => _invoiceNumber;
  List<VehiclePurchase> get purchases => _purchases;
  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canCreatePurchase =>
      _selectedCustomer != null &&
      _selectedVehicle != null &&
      _purchasePrice > 0;

  VehiclePurchaseProvider() {
    _generateInvoiceNumber();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd-HHmmss');
    _invoiceNumber = 'PB-${formatter.format(now)}';
  }

  void setCustomer(Customer? customer) {
    _selectedCustomer = customer;
    // Reset vehicle when customer changes
    _selectedVehicle = null;
    notifyListeners();
  }

  void setVehicle(CustomerVehicle? vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void setPurchasePrice(double price) {
    _purchasePrice = price;
    notifyListeners();
  }

  void setCondition(String condition) {
    _condition = condition;
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void setNextAction(String action) {
    _nextAction = action;
    notifyListeners();
  }

  void clearForm() {
    _selectedCustomer = null;
    _selectedVehicle = null;
    _purchasePrice = 0.0;
    _condition = 'Baik';
    _notes = '';
    _nextAction = 'servis';
    _generateInvoiceNumber();
    notifyListeners();
  }

  // API calls for Vehicle Purchase endpoints
  Future<bool> createPurchase() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final purchaseData = {
        'invoice_number': _invoiceNumber,
        'customer_id': _selectedCustomer!.customerId,
        'vehicle_id': _selectedVehicle!.vehicleId,
        'purchase_price': _purchasePrice,
        'condition': _condition,
        'notes': _notes,
        'next_action': _nextAction,
      };

      final response = await _apiService.post<VehiclePurchase>(
        '/vehicles/purchase',
        data: purchaseData,
        fromJson: (json) => VehiclePurchase.fromJson(json),
      );

      if (response.success && response.data != null) {
        _purchases.insert(0, response.data!);
        clearForm();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadPurchases() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<VehiclePurchase>>(
        '/vehicles/purchases',
        fromJson: (json) => (json as List)
            .map((item) => VehiclePurchase.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _purchases = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final response = await _apiService.get<Vehicle>(
        '/vehicles/$vehicleId',
        fromJson: (json) => Vehicle.fromJson(json),
      );

      if (response.success && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error getting vehicle: $e');
      return null;
    }
  }

  Future<void> loadVehicles({String? status}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      Map<String, dynamic> queryParams = {};
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _apiService.get<List<Vehicle>>(
        '/vehicles',
        queryParameters: queryParams,
        fromJson: (json) => (json as List)
            .map((item) => Vehicle.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _vehicles = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
