import '../../core/api/api_service.dart';
import '../../shared/models/api_response.dart';
import '../../shared/models/product.dart';

class ProductRepository {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<ApiResponse<List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Product>>(
      '/products',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Product.fromJson,
    );
  }

  // Get product by ID
  Future<ApiResponse<Product>> getProduct(int id) async {
    return await _apiService.get<Product>(
      '/products/$id',
      fromJson: Product.fromJson,
    );
  }

  // Get product by SKU
  Future<ApiResponse<Product>> getProductBySku(String sku) async {
    return await _apiService.get<Product>(
      '/products/sku',
      queryParameters: {
        'sku': sku,
      },
      fromJson: Product.fromJson,
    );
  }

  // Get product by barcode
  Future<ApiResponse<Product>> getProductByBarcode(String barcode) async {
    return await _apiService.get<Product>(
      '/products/barcode',
      queryParameters: {
        'barcode': barcode,
      },
      fromJson: Product.fromJson,
    );
  }

  // Search products
  Future<ApiResponse<List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Product>>(
      '/products/search',
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Product.fromJson,
    );
  }

  // Get products by category
  Future<ApiResponse<List<Product>>> getProductsByCategory(int categoryId) async {
    return await _apiService.get<List<Product>>(
      '/categories/$categoryId/products',
      fromJson: Product.fromJson,
    );
  }

  // Get products by supplier
  Future<ApiResponse<List<Product>>> getProductsBySupplier(int supplierId) async {
    return await _apiService.get<List<Product>>(
      '/suppliers/$supplierId/products',
      fromJson: Product.fromJson,
    );
  }
}

class CategoryRepository {
  final ApiService _apiService = ApiService();

  // Get all categories
  Future<ApiResponse<List<Category>>> getCategories({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Category>>(
      '/categories',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Category.fromJson,
    );
  }

  // Get category by ID
  Future<ApiResponse<Category>> getCategory(int id) async {
    return await _apiService.get<Category>(
      '/categories/$id',
      fromJson: Category.fromJson,
    );
  }
}

class SupplierRepository {
  final ApiService _apiService = ApiService();

  // Get all suppliers
  Future<ApiResponse<List<Supplier>>> getSuppliers({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Supplier>>(
      '/suppliers',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Supplier.fromJson,
    );
  }

  // Get supplier by ID
  Future<ApiResponse<Supplier>> getSupplier(int id) async {
    return await _apiService.get<Supplier>(
      '/suppliers/$id',
      fromJson: Supplier.fromJson,
    );
  }

  // Search suppliers
  Future<ApiResponse<List<Supplier>>> searchSuppliers({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Supplier>>(
      '/suppliers/search',
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Supplier.fromJson,
    );
  }
}

class UnitTypeRepository {
  final ApiService _apiService = ApiService();

  // Get all unit types
  Future<ApiResponse<List<UnitType>>> getUnitTypes() async {
    return await _apiService.get<List<UnitType>>(
      '/unit-types',
      fromJson: UnitType.fromJson,
    );
  }

  // Get unit type by ID
  Future<ApiResponse<UnitType>> getUnitType(int id) async {
    return await _apiService.get<UnitType>(
      '/unit-types/$id',
      fromJson: UnitType.fromJson,
    );
  }
}