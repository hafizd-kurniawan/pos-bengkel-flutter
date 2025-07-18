import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/product.dart';

class ProductRepository {
  final ApiService _apiService;

  ProductRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // GET /api/v1/products - Sesuai endpoint di README.md
  Future<ApiResponse<List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      return await _apiService.get<List<Product>>(
        '/products',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) => Product.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Product>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil data produk: $e');
    }
  }

  // GET /api/v1/products/:id - Sesuai endpoint di README.md
  Future<ApiResponse<Product>> getProductById(String id) async {
    try {
      return await _apiService.get<Product>(
        '/products/$id',
        fromJson: (data) => Product.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil detail produk: $e');
    }
  }

  // GET /api/v1/products/barcode/:barcode - Sesuai endpoint di README.md
  Future<ApiResponse<Product>> getProductByBarcode(String barcode) async {
    try {
      return await _apiService.get<Product>(
        '/products/barcode/$barcode',
        fromJson: (data) => Product.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mencari produk dengan barcode: $e');
    }
  }

  // GET /api/v1/products/sku/:sku - Sesuai endpoint di README.md
  Future<ApiResponse<Product>> getProductBySku(String sku) async {
    try {
      return await _apiService.get<Product>(
        '/products/sku/$sku',
        fromJson: (data) => Product.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mencari produk dengan SKU: $e');
    }
  }

  // GET /api/v1/products/search - Sesuai endpoint di README.md
  Future<ApiResponse<List<Product>>> searchProducts(String query) async {
    try {
      final queryParams = {
        'search': query,
      };

      return await _apiService.get<List<Product>>(
        '/products/search',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) => Product.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Product>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mencari produk: $e');
    }
  }
}
