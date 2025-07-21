import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/shared/models/installment.dart';
import 'package:pos_bengkel/core/services/api_service.dart';

class InstallmentProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Current payment form data
  String? _selectedInstallmentId;
  double _paymentAmount = 0.0;
  String _paymentMethod = 'cash';
  String _notes = '';

  // Data lists
  List<Installment> _installments = [];
  List<InstallmentPayment> _payments = [];
  List<InstallmentPayment> _overduePayments = [];
  List<InstallmentSchedule> _currentSchedule = [];
  Installment? _currentInstallment;
  InstallmentPayment? _currentPayment;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get selectedInstallmentId => _selectedInstallmentId;
  double get paymentAmount => _paymentAmount;
  String get paymentMethod => _paymentMethod;
  String get notes => _notes;
  
  List<Installment> get installments => _installments;
  List<InstallmentPayment> get payments => _payments;
  List<InstallmentPayment> get overduePayments => _overduePayments;
  List<InstallmentSchedule> get currentSchedule => _currentSchedule;
  Installment? get currentInstallment => _currentInstallment;
  InstallmentPayment? get currentPayment => _currentPayment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canProcessPayment =>
      _selectedInstallmentId != null &&
      _paymentAmount > 0;

  // Form setters
  void setSelectedInstallmentId(String? installmentId) {
    _selectedInstallmentId = installmentId;
    if (installmentId != null) {
      loadInstallmentById(installmentId);
    }
    notifyListeners();
  }

  void setPaymentAmount(double amount) {
    _paymentAmount = amount;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void clearPaymentForm() {
    _selectedInstallmentId = null;
    _paymentAmount = 0.0;
    _paymentMethod = 'cash';
    _notes = '';
    _currentInstallment = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // API Methods

  /// POST /api/v1/vehicles/installments/payments - Process installment payment
  Future<bool> processInstallmentPayment() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final paymentData = {
        'installment_id': _selectedInstallmentId,
        'amount': _paymentAmount,
        'payment_method': _paymentMethod,
        'notes': _notes,
      };

      final response = await _apiService.post<InstallmentPayment>(
        '/vehicles/installments/payments',
        data: paymentData,
        fromJson: (json) => InstallmentPayment.fromJson(json),
      );

      if (response.success && response.data != null) {
        _payments.insert(0, response.data!);
        _currentPayment = response.data!;
        
        // Update installment remaining amount if necessary
        if (_currentInstallment != null) {
          _currentInstallment = _currentInstallment!.copyWith(
            remainingAmount: _currentInstallment!.remainingAmount - _paymentAmount,
          );
          
          // Update in installments list
          final installmentIndex = _installments.indexWhere(
            (inst) => inst.installmentId == _selectedInstallmentId,
          );
          if (installmentIndex != -1) {
            _installments[installmentIndex] = _currentInstallment!;
          }
        }

        clearPaymentForm();
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

  /// GET /api/v1/vehicles/installments/:id - Get installment by ID
  Future<Installment?> loadInstallmentById(String installmentId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<Installment>(
        '/vehicles/installments/$installmentId',
        fromJson: (json) => Installment.fromJson(json),
      );

      _isLoading = false;
      notifyListeners();

      if (response.success && response.data != null) {
        _currentInstallment = response.data!;
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

  /// GET /api/v1/vehicles/installments/:id/schedule - Generate installment schedule
  Future<void> loadInstallmentSchedule(String installmentId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<InstallmentSchedule>>(
        '/vehicles/installments/$installmentId/schedule',
        fromJson: (json) => (json as List)
            .map((item) => InstallmentSchedule.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _currentSchedule = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET /api/v1/vehicles/installments/:installment_id/payments - Get installment payments
  Future<void> loadInstallmentPayments(String installmentId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<InstallmentPayment>>(
        '/vehicles/installments/$installmentId/payments',
        fromJson: (json) => (json as List)
            .map((item) => InstallmentPayment.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _payments = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET /api/v1/vehicles/installments/overdue - Get overdue payments
  Future<void> loadOverduePayments() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<InstallmentPayment>>(
        '/vehicles/installments/overdue',
        fromJson: (json) => (json as List)
            .map((item) => InstallmentPayment.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _overduePayments = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// GET /api/v1/vehicles/installments/payments/:payment_id/late-fee - Calculate late fee
  Future<double> calculateLateFee(String paymentId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '/vehicles/installments/payments/$paymentId/late-fee',
      );

      if (response.success && response.data != null) {
        return double.tryParse(response.data!['late_fee']?.toString() ?? '0') ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      print('Error calculating late fee: $e');
      return 0.0;
    }
  }

  /// Load all installments
  Future<void> loadAllInstallments() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<Installment>>(
        '/vehicles/installments',
        fromJson: (json) => (json as List)
            .map((item) => Installment.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _installments = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load active installments
  Future<void> loadActiveInstallments() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<Installment>>(
        '/vehicles/installments',
        queryParameters: {'status': 'active'},
        fromJson: (json) => (json as List)
            .map((item) => Installment.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _installments = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Helper method to get installment by ID from current list
  Installment? getInstallmentById(String installmentId) {
    try {
      return _installments.firstWhere((inst) => inst.installmentId == installmentId);
    } catch (e) {
      return null;
    }
  }

  /// Calculate total payments made for an installment
  double getTotalPaymentsMade(String installmentId) {
    return _payments
        .where((payment) => 
            payment.installmentId == installmentId && 
            payment.status == 'paid')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  /// Calculate remaining balance for an installment
  double getRemainingBalance(String installmentId) {
    final installment = getInstallmentById(installmentId);
    if (installment == null) return 0.0;

    final totalPaid = getTotalPaymentsMade(installmentId);
    return installment.totalAmount - installment.downPayment - totalPaid;
  }

  /// Get next payment due date for an installment
  DateTime? getNextPaymentDueDate(String installmentId) {
    final payments = _payments.where((p) => 
        p.installmentId == installmentId && 
        p.status == 'pending').toList();
    
    if (payments.isEmpty) return null;
    
    payments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return payments.first.dueDate;
  }
}