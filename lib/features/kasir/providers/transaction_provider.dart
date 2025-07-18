import 'package:flutter/foundation.dart';
import '../../../core/api/transaction_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final CashFlowRepository _cashFlowRepository = CashFlowRepository();
  final PaymentMethodRepository _paymentMethodRepository = PaymentMethodRepository();

  List<Transaction> _transactions = [];
  List<CashFlow> _cashFlows = [];
  List<PaymentMethod> _paymentMethods = [];
  Transaction? _selectedTransaction;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<CashFlow> get cashFlows => _cashFlows;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  Transaction? get selectedTransaction => _selectedTransaction;
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

  // Load transactions
  Future<void> loadTransactions({int page = 1, int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _transactionRepository.getTransactions(
        page: page,
        limit: limit,
      );

      if (response.data != null) {
        if (page == 1) {
          _transactions = response.data!;
        } else {
          _transactions.addAll(response.data!);
        }
      }
    } catch (e) {
      _setError('Gagal memuat data transaksi: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create transaction
  Future<Transaction?> createTransaction({
    required DateTime transactionDate,
    required int userId,
    int? customerId,
    required int outletId,
    required String transactionType,
    String status = 'sukses',
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _transactionRepository.createTransaction(
        transactionDate: transactionDate,
        userId: userId,
        customerId: customerId,
        outletId: outletId,
        transactionType: transactionType,
        status: status,
      );

      if (response.data != null) {
        _transactions.insert(0, response.data!);
        notifyListeners();
        return response.data!;
      }
      return null;
    } catch (e) {
      _setError('Gagal membuat transaksi: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Update transaction status
  Future<bool> updateTransactionStatus(int id, String status) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _transactionRepository.updateTransaction(
        id,
        status: status,
      );

      if (response.data != null) {
        final index = _transactions.indexWhere((t) => t.transactionId == id);
        if (index != -1) {
          _transactions[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui status transaksi: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get transaction invoice
  Future<Transaction?> getTransactionInvoice(int id) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _transactionRepository.getTransactionInvoice(id);
      return response.data;
    } catch (e) {
      _setError('Gagal memuat invoice: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Get transactions by customer
  Future<void> loadTransactionsByCustomer(int customerId) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _transactionRepository.getTransactionsByCustomer(customerId);

      if (response.data != null) {
        _transactions = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat transaksi pelanggan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get transactions by date range
  Future<void> loadTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _transactionRepository.getTransactionsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      if (response.data != null) {
        _transactions = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat transaksi berdasarkan tanggal: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Select transaction
  void selectTransaction(Transaction transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  // Clear selected transaction
  void clearSelectedTransaction() {
    _selectedTransaction = null;
    notifyListeners();
  }

  // Load cash flows
  Future<void> loadCashFlows({int page = 1, int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _cashFlowRepository.getCashFlows(
        page: page,
        limit: limit,
      );

      if (response.data != null) {
        if (page == 1) {
          _cashFlows = response.data!;
        } else {
          _cashFlows.addAll(response.data!);
        }
      }
    } catch (e) {
      _setError('Gagal memuat data arus kas: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create cash flow
  Future<bool> createCashFlow({
    required int userId,
    required int outletId,
    required String flowType,
    required double amount,
    required String description,
    required DateTime flowDate,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _cashFlowRepository.createCashFlow(
        userId: userId,
        outletId: outletId,
        flowType: flowType,
        amount: amount,
        description: description,
        flowDate: flowDate,
      );

      if (response.data != null) {
        _cashFlows.insert(0, response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal membuat arus kas: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update cash flow
  Future<bool> updateCashFlow(
    int id, {
    String? flowType,
    double? amount,
    String? description,
    DateTime? flowDate,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _cashFlowRepository.updateCashFlow(
        id,
        flowType: flowType,
        amount: amount,
        description: description,
        flowDate: flowDate,
      );

      if (response.data != null) {
        final index = _cashFlows.indexWhere((c) => c.cashFlowId == id);
        if (index != -1) {
          _cashFlows[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui arus kas: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get cash flows by type
  Future<void> loadCashFlowsByType(String flowType) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _cashFlowRepository.getCashFlowsByType(flowType);

      if (response.data != null) {
        _cashFlows = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat arus kas berdasarkan tipe: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load payment methods
  Future<void> loadPaymentMethods() async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _paymentMethodRepository.getPaymentMethods();

      if (response.data != null) {
        _paymentMethods = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat metode pembayaran: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get income cash flows
  List<CashFlow> get incomeCashFlows => 
      _cashFlows.where((cf) => cf.flowType == AppConstants.cashFlowIncome).toList();

  // Get expense cash flows
  List<CashFlow> get expenseCashFlows => 
      _cashFlows.where((cf) => cf.flowType == AppConstants.cashFlowExpense).toList();

  // Get successful transactions
  List<Transaction> get successfulTransactions => 
      _transactions.where((t) => t.status == AppConstants.transactionSuccess).toList();

  // Get pending transactions
  List<Transaction> get pendingTransactions => 
      _transactions.where((t) => t.status == AppConstants.transactionPending).toList();

  // Calculate total income
  double get totalIncome {
    return incomeCashFlows.fold(0.0, (sum, cf) => sum + cf.amount);
  }

  // Calculate total expense
  double get totalExpense {
    return expenseCashFlows.fold(0.0, (sum, cf) => sum + cf.amount);
  }

  // Calculate net income
  double get netIncome {
    return totalIncome - totalExpense;
  }
}