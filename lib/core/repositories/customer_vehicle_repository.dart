import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class CustomerVehicleRepository {
  final ApiService _apiService;

  CustomerVehicleRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // GET /api/v1/customer-vehicles - Sesuai endpoint di README.md
  Future<ApiResponse<List<CustomerVehicle>>> getCustomerVehicles({
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

      return await _apiService.get<List<CustomerVehicle>>(
        '/customer-vehicles',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) =>
                    CustomerVehicle.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <CustomerVehicle>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil data kendaraan: $e');
    }
  }

  // GET /api/v1/customer-vehicles/:id - GET SINGLE VEHICLE BY ID
  Future<ApiResponse<List<CustomerVehicle>>> getVehiclesByCustomerId(
      String customerId) async {
    try {
      print('🚀 Calling API: /customer-vehicles/$customerId');

      // Call API service directly without specifying fromJson first
      final response = await _apiService.get<Map<String, dynamic>>(
        '/customer-vehicles/$customerId',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      print('📦 Raw API Response: ${response.data}');

      if (response.success && response.data != null) {
        try {
          // Parse the vehicle from the response data
          final vehicleData = response.data!;
          final vehicle = CustomerVehicle.fromJson(vehicleData);

          print('✅ Parsed vehicle: ${vehicle.displayName}');

          // Return as list with 1 item
          return ApiResponse<List<CustomerVehicle>>(
            success: true,
            message: response.message,
            data: [vehicle],
          );
        } catch (parseError) {
          print('❌ Parse error: $parseError');
          return ApiResponse<List<CustomerVehicle>>(
            success: false,
            message: 'Gagal parsing data kendaraan: $parseError',
            data: [],
          );
        }
      } else {
        print('❌ API Response failed: ${response.message}');
        return ApiResponse<List<CustomerVehicle>>(
          success: false,
          message: response.message ?? 'Gagal mengambil data kendaraan',
          data: [],
        );
      }
    } on ApiException catch (e) {
      print('❌ API Exception: $e');
      rethrow;
    } catch (e) {
      print('❌ General Exception: $e');
      throw ApiException('Gagal mengambil data kendaraan pelanggan: $e');
    }
  }

  // GET /api/v1/customer-vehicles/:id - Sesuai endpoint di README.md
  Future<ApiResponse<CustomerVehicle>> getCustomerVehicleById(String id) async {
    try {
      return await _apiService.get<CustomerVehicle>(
        '/customer-vehicles/$id',
        fromJson: (data) =>
            CustomerVehicle.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil detail kendaraan: $e');
    }
  }

  // POST /api/v1/customer-vehicles - Sesuai endpoint di README.md
  Future<ApiResponse<CustomerVehicle>> createCustomerVehicle(
      CustomerVehicle vehicle) async {
    try {
      return await _apiService.post<CustomerVehicle>(
        '/customer-vehicles',
        data: {
          'customer_id': int.parse(vehicle.customerId),
          'plate_number': vehicle.plateNumber,
          'type': vehicle.type,
          'brand': vehicle.brand,
          'model': vehicle.model,
          'production_year': vehicle.productionYear,
          'engine_number': vehicle.engineNumber,
          'chassis_number': vehicle.chassisNumber,
          'color': vehicle.color,
        },
        fromJson: (data) =>
            CustomerVehicle.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal membuat data kendaraan: $e');
    }
  }

  // PUT /api/v1/customer-vehicles/:id - Sesuai endpoint di README.md
  Future<ApiResponse<CustomerVehicle>> updateCustomerVehicle(
      String id, CustomerVehicle vehicle) async {
    try {
      return await _apiService.put<CustomerVehicle>(
        '/customer-vehicles/$id',
        data: {
          'customer_id': int.parse(vehicle.customerId),
          'plate_number': vehicle.plateNumber,
          'type': vehicle.type,
          'brand': vehicle.brand,
          'model': vehicle.model,
          'production_year': vehicle.productionYear,
          'engine_number': vehicle.engineNumber,
          'chassis_number': vehicle.chassisNumber,
          'color': vehicle.color,
        },
        fromJson: (data) =>
            CustomerVehicle.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal memperbarui data kendaraan: $e');
    }
  }

  // GET /api/v1/customer-vehicles/search - Sesuai endpoint di README.md
  Future<ApiResponse<List<CustomerVehicle>>> searchCustomerVehicles(
      String query) async {
    try {
      final queryParams = {
        'search': query,
      };

      return await _apiService.get<List<CustomerVehicle>>(
        '/customer-vehicles/search',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) =>
                    CustomerVehicle.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <CustomerVehicle>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mencari kendaraan: $e');
    }
  }
}
