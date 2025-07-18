import '../core/api/api_service.dart';
import '../shared/models/api_response.dart';
import '../shared/models/service.dart';

class ServiceRepository {
  final ApiService _apiService = ApiService();

  // Get all services
  Future<ApiResponse<List<Service>>> getServices({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Service>>(
      '/services',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Service.fromJson,
    );
  }

  // Get service by ID
  Future<ApiResponse<Service>> getService(int id) async {
    return await _apiService.get<Service>(
      '/services/$id',
      fromJson: Service.fromJson,
    );
  }

  // Get service by code
  Future<ApiResponse<Service>> getServiceByCode(String serviceCode) async {
    return await _apiService.get<Service>(
      '/services/code',
      queryParameters: {
        'service_code': serviceCode,
      },
      fromJson: Service.fromJson,
    );
  }

  // Search services
  Future<ApiResponse<List<Service>>> searchServices({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Service>>(
      '/services/search',
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Service.fromJson,
    );
  }
}

class ServiceJobRepository {
  final ApiService _apiService = ApiService();

  // Get all service jobs
  Future<ApiResponse<List<ServiceJob>>> getServiceJobs({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<ServiceJob>>(
      '/service-jobs',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: ServiceJob.fromJson,
    );
  }

  // Get service job by ID
  Future<ApiResponse<ServiceJob>> getServiceJob(int id) async {
    return await _apiService.get<ServiceJob>(
      '/service-jobs/$id',
      fromJson: ServiceJob.fromJson,
    );
  }

  // Create service job
  Future<ApiResponse<ServiceJob>> createServiceJob({
    required String serviceCode,
    required int customerId,
    required int vehicleId,
    required int userId,
    required int outletId,
    required DateTime serviceDate,
    required String complaint,
    String? diagnosis,
    required double estimatedCost,
    String status = 'Pending',
    String? notes,
  }) async {
    return await _apiService.post<ServiceJob>(
      '/service-jobs',
      body: {
        'service_code': serviceCode,
        'customer_id': customerId,
        'vehicle_id': vehicleId,
        'user_id': userId,
        'outlet_id': outletId,
        'service_date': serviceDate.toIso8601String(),
        'complaint': complaint,
        'diagnosis': diagnosis,
        'estimated_cost': estimatedCost,
        'status': status,
        'notes': notes,
      },
      fromJson: ServiceJob.fromJson,
    );
  }

  // Update service job
  Future<ApiResponse<ServiceJob>> updateServiceJob(
    int id, {
    String? diagnosis,
    double? actualCost,
    String? notes,
  }) async {
    final body = <String, dynamic>{};
    if (diagnosis != null) body['diagnosis'] = diagnosis;
    if (actualCost != null) body['actual_cost'] = actualCost;
    if (notes != null) body['notes'] = notes;

    return await _apiService.put<ServiceJob>(
      '/service-jobs/$id',
      body: body,
      fromJson: ServiceJob.fromJson,
    );
  }

  // Update service job status
  Future<ApiResponse<ServiceJob>> updateServiceJobStatus(
    int id, {
    required String status,
    String? statusNotes,
  }) async {
    return await _apiService.put<ServiceJob>(
      '/service-jobs/$id/status',
      body: {
        'status': status,
        'status_notes': statusNotes,
      },
      fromJson: ServiceJob.fromJson,
    );
  }

  // Get service jobs by status
  Future<ApiResponse<List<ServiceJob>>> getServiceJobsByStatus({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<ServiceJob>>(
      '/service-jobs/status',
      queryParameters: {
        'status': status,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: ServiceJob.fromJson,
    );
  }

  // Get service jobs by customer
  Future<ApiResponse<List<ServiceJob>>> getServiceJobsByCustomer({
    required int customerId,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<ServiceJob>>(
      '/customers/$customerId/service-jobs',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: ServiceJob.fromJson,
    );
  }

  // Get service job by service code
  Future<ApiResponse<ServiceJob>> getServiceJobByCode(String serviceCode) async {
    return await _apiService.get<ServiceJob>(
      '/service-jobs/service-code',
      queryParameters: {
        'service_code': serviceCode,
      },
      fromJson: ServiceJob.fromJson,
    );
  }
}

class ServiceDetailRepository {
  final ApiService _apiService = ApiService();

  // Create service detail
  Future<ApiResponse<ServiceDetail>> createServiceDetail({
    required int serviceJobId,
    required int serviceId,
    required int quantity,
    required double unitPrice,
    double discount = 0,
    String? notes,
  }) async {
    return await _apiService.post<ServiceDetail>(
      '/service-details',
      body: {
        'service_job_id': serviceJobId,
        'service_id': serviceId,
        'quantity': quantity,
        'unit_price': unitPrice,
        'discount': discount,
        'notes': notes,
      },
      fromJson: ServiceDetail.fromJson,
    );
  }

  // Update service detail
  Future<ApiResponse<ServiceDetail>> updateServiceDetail(
    int id, {
    int? quantity,
    double? unitPrice,
    double? discount,
    String? notes,
  }) async {
    final body = <String, dynamic>{};
    if (quantity != null) body['quantity'] = quantity;
    if (unitPrice != null) body['unit_price'] = unitPrice;
    if (discount != null) body['discount'] = discount;
    if (notes != null) body['notes'] = notes;

    return await _apiService.put<ServiceDetail>(
      '/service-details/$id',
      body: body,
      fromJson: ServiceDetail.fromJson,
    );
  }

  // Delete service detail
  Future<ApiResponse<void>> deleteServiceDetail(int id) async {
    return await _apiService.delete<void>('/service-details/$id');
  }

  // Get service details for a service job
  Future<ApiResponse<List<ServiceDetail>>> getServiceDetailsByJob(
      int serviceJobId) async {
    return await _apiService.get<List<ServiceDetail>>(
      '/service-jobs/$serviceJobId/details',
      fromJson: ServiceDetail.fromJson,
    );
  }
}

class ServiceJobHistoryRepository {
  final ApiService _apiService = ApiService();

  // Get service job history
  Future<ApiResponse<List<ServiceJobHistory>>> getServiceJobHistory(
      int serviceJobId) async {
    return await _apiService.get<List<ServiceJobHistory>>(
      '/service-jobs/$serviceJobId/histories',
      fromJson: ServiceJobHistory.fromJson,
    );
  }
}