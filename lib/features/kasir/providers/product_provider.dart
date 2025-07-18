import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/core/repositories/product_repository.dart';
import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  List<Product> _products = [];
  List<Product> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';

  // Getters
  List<Product> get products => _products;
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  ProductProvider({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  Future<void> loadProducts({
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

      final response = await _repository.getProducts(
        page: page,
        limit: limit,
        search: search,
      );

      if (response.success) {
        if (page == 1) {
          _products = response.data ?? [];
        } else {
          _products.addAll(response.data ?? []);
        }
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      _isSearching = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.getProductByBarcode(barcode);

      if (response.success) {
        _errorMessage = null;
        return response.data;
      } else {
        _errorMessage = response.message;
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error getting product by barcode: $e');
      return null;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
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

      final response = await _repository.searchProducts(query);

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
      debugPrint('Error searching products: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
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
