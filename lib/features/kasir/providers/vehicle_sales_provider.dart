import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/shared/models/vehicle_sales.dart';
import 'package:pos_bengkel/shared/models/vehicle.dart';
import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/core/services/api_service.dart';

class VehicleSalesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Current sale form data
  String? _selectedVehicleId;
  String? _selectedCustomerId;
  String _customerName = '';
  double _salePrice = 0.0;
  String _paymentMethod = 'cash';
  double _downPayment = 0.0;
  int _installmentMonths = 0;
  double _monthlyPayment = 0.0;
  String _notes = '';
  String _invoiceNumber = '';

  // Data lists
  List<VehicleSalesTransaction> _salesTransactions = [];
  List<Vehicle> _availableVehicles = [];
  List<Vehicle> _forSaleVehicles = [];
  VehicleSalesTransaction? _currentTransaction;
  VehicleProfit? _currentVehicleProfit;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get selectedVehicleId => _selectedVehicleId;
  String? get selectedCustomerId => _selectedCustomerId;
  String get customerName => _customerName;
  double get salePrice => _salePrice;
  String get paymentMethod => _paymentMethod;
  double get downPayment => _downPayment;
  int get installmentMonths => _installmentMonths;
  double get monthlyPayment => _monthlyPayment;
  String get notes => _notes;
  String get invoiceNumber => _invoiceNumber;
  
  List<VehicleSalesTransaction> get salesTransactions => _salesTransactions;
  List<Vehicle> get availableVehicles => _availableVehicles;
  List<Vehicle> get forSaleVehicles => _forSaleVehicles;
  VehicleSalesTransaction? get currentTransaction => _currentTransaction;
  VehicleProfit? get currentVehicleProfit => _currentVehicleProfit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canCreateSale =>
      _selectedVehicleId != null &&
      _selectedCustomerId != null &&
      _customerName.isNotEmpty &&
      _salePrice > 0;

  bool get isInstallmentPayment => _paymentMethod == 'installment';
  double get remainingAmount => _salePrice - _downPayment;

  VehicleSalesProvider() {
    _generateInvoiceNumber();
    loadForSaleVehicles();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd-HHmmss');
    _invoiceNumber = 'VS-${formatter.format(now)}';
  }

  // Form setters
  void setSelectedVehicleId(String? vehicleId) {
    _selectedVehicleId = vehicleId;
    notifyListeners();
  }

  void setSelectedCustomerId(String? customerId) {
    _selectedCustomerId = customerId;
    notifyListeners();
  }

  void setCustomerName(String name) {
    _customerName = name;
    notifyListeners();
  }

  void setSalePrice(double price) {
    _salePrice = price;
    _calculateMonthlyPayment();
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    if (method != 'installment') {
      _downPayment = 0.0;
      _installmentMonths = 0;
      _monthlyPayment = 0.0;
    }
    notifyListeners();
  }

  void setDownPayment(double amount) {
    _downPayment = amount;
    _calculateMonthlyPayment();
    notifyListeners();
  }

  void setInstallmentMonths(int months) {
    _installmentMonths = months;
    _calculateMonthlyPayment();
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void _calculateMonthlyPayment() {
    if (_paymentMethod == 'installment' && _installmentMonths > 0) {
      final remaining = _salePrice - _downPayment;
      _monthlyPayment = remaining / _installmentMonths;
    } else {
      _monthlyPayment = 0.0;
    }
  }

  void clearForm() {
    _selectedVehicleId = null;
    _selectedCustomerId = null;
    _customerName = '';
    _salePrice = 0.0;
    _paymentMethod = 'cash';
    _downPayment = 0.0;
    _installmentMonths = 0;
    _monthlyPayment = 0.0;
    _notes = '';
    _generateInvoiceNumber();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // API Methods

  /// POST /api/v1/vehicles/sales - Sell vehicle
  Future<bool> sellVehicle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final saleData = {
        'vehicle_id': _selectedVehicleId,
        'invoice_number': _invoiceNumber,
        'customer_id': _selectedCustomerId,
        'customer_name': _customerName,
        'sale_price': _salePrice,
        'payment_method': _paymentMethod,
        'down_payment': _paymentMethod == 'installment' ? _downPayment : null,
        'installment_months': _paymentMethod == 'installment' ? _installmentMonths : null,
        'monthly_payment': _paymentMethod == 'installment' ? _monthlyPayment : null,
        'notes': _notes,
      };

      final response = await _apiService.post<VehicleSalesTransaction>(
        '/vehicles/sales',
        data: saleData,
        fromJson: (json) => VehicleSalesTransaction.fromJson(json),
      );

      if (response.success && response.data != null) {
        _salesTransactions.insert(0, response.data!);
        _currentTransaction = response.data!;
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

  /// PUT /api/v1/vehicles/sales/:id/mark-for-sale - Mark vehicle for sale
  Future<bool> markVehicleForSale(String vehicleId, double salePrice) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final data = {'sale_price': salePrice};

      final response = await _apiService.put<Vehicle>(
        '/vehicles/sales/$vehicleId/mark-for-sale',
        data: data,
        fromJson: (json) => Vehicle.fromJson(json),
      );

      if (response.success && response.data != null) {
        // Update vehicle in appropriate list
        final vehicleIndex = _availableVehicles.indexWhere((v) => v.vehicleId == vehicleId);
        if (vehicleIndex != -1) {
          _availableVehicles.removeAt(vehicleIndex);
          _forSaleVehicles.add(response.data!);
        }

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

  /// GET /api/v1/vehicles/sales/by-status - Get vehicles by sale status
  Future<void> loadVehiclesByStatus(String status) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<Vehicle>>(
        '/vehicles/sales/by-status',
        queryParameters: {'status': status},
        fromJson: (json) => (json as List)
            .map((item) => Vehicle.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        switch (status) {
          case 'for_sale':
            _forSaleVehicles = response.data!;
            break;
          case 'available':
            _availableVehicles = response.data!;
            break;
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET /api/v1/vehicles/sales/transactions/:id - Get sales transaction by ID
  Future<VehicleSalesTransaction?> getSalesTransactionById(String transactionId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<VehicleSalesTransaction>(
        '/vehicles/sales/transactions/$transactionId',
        fromJson: (json) => VehicleSalesTransaction.fromJson(json),
      );

      _isLoading = false;
      notifyListeners();

      if (response.success && response.data != null) {
        _currentTransaction = response.data!;
        return response.data;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// GET /api/v1/vehicles/sales/:id/profit - Calculate profit for vehicle
  Future<VehicleProfit?> calculateVehicleProfit(String vehicleId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<VehicleProfit>(
        '/vehicles/sales/$vehicleId/profit',
        fromJson: (json) => VehicleProfit.fromJson(json),
      );

      _isLoading = false;
      notifyListeners();

      if (response.success && response.data != null) {
        _currentVehicleProfit = response.data!;
        return response.data;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Load all sales transactions
  Future<void> loadSalesTransactions() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<VehicleSalesTransaction>>(
        '/vehicles/sales/transactions',
        fromJson: (json) => (json as List)
            .map((item) => VehicleSalesTransaction.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _salesTransactions = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load vehicles that are for sale
  Future<void> loadForSaleVehicles() async {
    await loadVehiclesByStatus('for_sale');
  }

  /// Load available vehicles that can be marked for sale
  Future<void> loadAvailableVehicles() async {
    await loadVehiclesByStatus('available');
  }

  /// Helper method to get vehicle by ID from current lists
  Vehicle? getVehicleById(String vehicleId) {
    Vehicle? vehicle;
    
    vehicle = _forSaleVehicles.firstWhere(
      (v) => v.vehicleId == vehicleId,
      orElse: () => _availableVehicles.firstWhere(
        (v) => v.vehicleId == vehicleId,
        orElse: () => Vehicle(
          plateNumber: '',
          type: '',
          brand: '',
          model: '',
          productionYear: 0,
          engineNumber: '',
          chassisNumber: '',
          color: '',
          condition: '',
          status: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );

    return vehicle.plateNumber.isNotEmpty ? vehicle : null;
  }
}