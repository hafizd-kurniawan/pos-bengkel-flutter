import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/core/repositories/customer_repository.dart';
import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/customer.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _repository;

  List<Customer> _customers = [];
  List<Customer> _searchResults = [];
  Customer? _selectedCustomer;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<Customer> get customers => _customers;
  List<Customer> get searchResults => _searchResults;
  Customer? get selectedCustomer => _selectedCustomer;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  CustomerProvider({CustomerRepository? repository})
      : _repository = repository ?? CustomerRepository();

  Future<void> loadCustomers({
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

      final response = await _repository.getCustomers(
        page: page,
        limit: limit,
        search: search,
      );

      if (response.success) {
        if (page == 1) {
          _customers = response.data ?? [];
        } else {
          _customers.addAll(response.data ?? []);
        }
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading customers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCustomer(Customer customer) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.createCustomer(customer);

      if (response.success) {
        _customers.insert(0, response.data!);
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
      debugPrint('Error creating customer: $e');
      return false;
    }
  }

  Future<void> searchCustomers(String query) async {
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

      final response = await _repository.searchCustomers(query);

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
      debugPrint('Error searching customers: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void selectCustomer(Customer? customer) {
    _selectedCustomer = customer;
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
