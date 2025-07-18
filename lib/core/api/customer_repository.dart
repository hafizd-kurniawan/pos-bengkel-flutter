import '../../core/api/api_service.dart';
import '../../shared/models/api_response.dart';
import '../../shared/models/customer.dart';

class CustomerRepository {
  final ApiService _apiService = ApiService();

  // Get all customers
  Future<ApiResponse<List<Customer>>> getCustomers({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Customer>>(
      '/customers',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Customer.fromJson,
    );
  }

  // Get customer by ID
  Future<ApiResponse<Customer>> getCustomer(int id) async {
    return await _apiService.get<Customer>(
      '/customers/$id',
      fromJson: Customer.fromJson,
    );
  }

  // Create customer
  Future<ApiResponse<Customer>> createCustomer({
    required String name,
    required String phoneNumber,
    String? address,
    String status = 'Aktif',
  }) async {
    return await _apiService.post<Customer>(
      '/customers',
      body: {
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'status': status,
      },
      fromJson: Customer.fromJson,
    );
  }

  // Update customer
  Future<ApiResponse<Customer>> updateCustomer(
    int id, {
    String? name,
    String? address,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (address != null) body['address'] = address;

    return await _apiService.put<Customer>(
      '/customers/$id',
      body: body,
      fromJson: Customer.fromJson,
    );
  }

  // Search customers
  Future<ApiResponse<List<Customer>>> searchCustomers({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Customer>>(
      '/customers/search',
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Customer.fromJson,
    );
  }

  // Get customer by phone number
  Future<ApiResponse<Customer>> getCustomerByPhone(String phoneNumber) async {
    return await _apiService.get<Customer>(
      '/customers/phone',
      queryParameters: {
        'phone_number': phoneNumber,
      },
      fromJson: Customer.fromJson,
    );
  }
}

class CustomerVehicleRepository {
  final ApiService _apiService = ApiService();

  // Get all customer vehicles
  Future<ApiResponse<List<CustomerVehicle>>> getCustomerVehicles({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<CustomerVehicle>>(
      '/customer-vehicles',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: CustomerVehicle.fromJson,
    );
  }

  // Get customer vehicle by ID
  Future<ApiResponse<CustomerVehicle>> getCustomerVehicle(int id) async {
    return await _apiService.get<CustomerVehicle>(
      '/customer-vehicles/$id',
      fromJson: CustomerVehicle.fromJson,
    );
  }

  // Create customer vehicle
  Future<ApiResponse<CustomerVehicle>> createCustomerVehicle({
    required int customerId,
    required String plateNumber,
    required String brand,
    required String model,
    required String type,
    required int productionYear,
    required String chassisNumber,
    required String engineNumber,
    required String color,
    String? notes,
  }) async {
    return await _apiService.post<CustomerVehicle>(
      '/customer-vehicles',
      body: {
        'customer_id': customerId,
        'plate_number': plateNumber,
        'brand': brand,
        'model': model,
        'type': type,
        'production_year': productionYear,
        'chassis_number': chassisNumber,
        'engine_number': engineNumber,
        'color': color,
        'notes': notes,
      },
      fromJson: CustomerVehicle.fromJson,
    );
  }

  // Update customer vehicle
  Future<ApiResponse<CustomerVehicle>> updateCustomerVehicle(
    int id, {
    String? model,
    String? color,
    String? notes,
  }) async {
    final body = <String, dynamic>{};
    if (model != null) body['model'] = model;
    if (color != null) body['color'] = color;
    if (notes != null) body['notes'] = notes;

    return await _apiService.put<CustomerVehicle>(
      '/customer-vehicles/$id',
      body: body,
      fromJson: CustomerVehicle.fromJson,
    );
  }

  // Search customer vehicles
  Future<ApiResponse<List<CustomerVehicle>>> searchCustomerVehicles({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<CustomerVehicle>>(
      '/customer-vehicles/search',
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: CustomerVehicle.fromJson,
    );
  }

  // Get vehicles for specific customer
  Future<ApiResponse<List<CustomerVehicle>>> getCustomerVehiclesByCustomer(
      int customerId) async {
    return await _apiService.get<List<CustomerVehicle>>(
      '/customers/$customerId/vehicles',
      fromJson: CustomerVehicle.fromJson,
    );
  }
}