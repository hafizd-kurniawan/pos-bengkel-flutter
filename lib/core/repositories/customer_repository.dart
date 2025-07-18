import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/customer.dart';

class CustomerRepository {
  final ApiService _apiService;

  CustomerRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // GET /api/v1/customers - Sesuai endpoint di README.md
  Future<ApiResponse<List<Customer>>> getCustomers({
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

      return await _apiService.get<List<Customer>>(
        '/customers',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) => Customer.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Customer>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil data pelanggan: $e');
    }
  }

  // GET /api/v1/customers/:id - Sesuai endpoint di README.md
  Future<ApiResponse<Customer>> getCustomerById(String id) async {
    try {
      return await _apiService.get<Customer>(
        '/customers/$id',
        fromJson: (data) => Customer.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil detail pelanggan: $e');
    }
  }

  // POST /api/v1/customers - Sesuai endpoint di README.md
  Future<ApiResponse<Customer>> createCustomer(Customer customer) async {
    try {
      return await _apiService.post<Customer>(
        '/customers',
        data: {
          'name': customer.name,
          'phone_number': customer.phoneNumber,
          'address': customer.address,
        },
        fromJson: (data) => Customer.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal membuat pelanggan baru: $e');
    }
  }

  // PUT /api/v1/customers/:id - Sesuai endpoint di README.md
  Future<ApiResponse<Customer>> updateCustomer(
      String id, Customer customer) async {
    try {
      return await _apiService.put<Customer>(
        '/customers/$id',
        data: {
          'name': customer.name,
          'phone_number': customer.phoneNumber,
          'address': customer.address,
        },
        fromJson: (data) => Customer.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal memperbarui data pelanggan: $e');
    }
  }

  // GET /api/v1/customers/search - Sesuai endpoint di README.md
  Future<ApiResponse<List<Customer>>> searchCustomers(String query) async {
    try {
      final queryParams = {
        'q': query,
      };

      return await _apiService.get<List<Customer>>(
        '/customers/search',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) => Customer.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Customer>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mencari pelanggan: $e');
    }
  }

  // GET /api/v1/customers/phone/:phone - Sesuai endpoint di README.md
  Future<ApiResponse<Customer>> getCustomerByPhone(String phone) async {
    try {
      return await _apiService.get<Customer>(
        '/customers/phone/$phone',
        fromJson: (data) => Customer.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mencari pelanggan dengan nomor telepon: $e');
    }
  }
}
