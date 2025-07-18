import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/core/repositories/transaction_repository.dart';
import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/core/utils/app_constants.dart';
import 'package:pos_bengkel/shared/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;

  List<Transaction> _transactions = [];
  List<Transaction> _unpaidTransactions = [];
  List<Transaction> _paidTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Transaction> get unpaidTransactions => _unpaidTransactions;
  List<Transaction> get paidTransactions => _paidTransactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TransactionProvider({TransactionRepository? repository})
      : _repository = repository ?? TransactionRepository();

  Future<void> loadTransactions({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    try {
      if (page == 1) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
      }

      final response = await _repository.getTransactions(
        page: page,
        limit: limit,
        search: search,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.success) {
        if (page == 1) {
          _transactions = response.data ?? [];
        } else {
          _transactions.addAll(response.data ?? []);
        }
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUnpaidTransactions() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.getTransactionsByStatus('pending');

      if (response.success) {
        _unpaidTransactions = response.data ?? [];
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading unpaid transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPaidTransactions() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.getTransactionsByStatus('sukses');

      if (response.success) {
        _paidTransactions = response.data ?? [];
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading paid transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.createTransaction(transactionData);

      if (response.success) {
        _transactions.insert(0, response.data!);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('Error creating transaction: $e');
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
