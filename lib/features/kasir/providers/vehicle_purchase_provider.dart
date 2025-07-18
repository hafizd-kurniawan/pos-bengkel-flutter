import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';
import 'package:pos_bengkel/shared/models/vehicle_purchase.dart';

class VehiclePurchaseProvider extends ChangeNotifier {
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

  // Simulate API calls for now - replace with actual API implementation
  Future<bool> createPurchase() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Create purchase object
      final purchase = VehiclePurchase(
        invoiceNumber: _invoiceNumber,
        customerId: _selectedCustomer!.customerId!,
        vehicleId: _selectedVehicle!.vehicleId!,
        purchasePrice: _purchasePrice,
        condition: _condition,
        notes: _notes,
        purchaseDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        status: 'sukses',
        nextAction: _nextAction,
        customer: _selectedCustomer,
        vehicle: _selectedVehicle,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add to purchases list
      _purchases.insert(0, purchase);

      // Clear form
      clearForm();

      _isLoading = false;
      notifyListeners();
      return true;
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

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, purchases are stored locally
      // In real implementation, this would call API

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
