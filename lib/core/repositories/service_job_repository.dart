import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';

class ServiceJobRepository {
  final ApiService _apiService;

  ServiceJobRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // GET /api/v1/service-jobs
  Future<ApiResponse<List<ServiceJob>>> getServiceJobs({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
      };

      return await _apiService.get<List<ServiceJob>>(
        '/service-jobs',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map(
                    (json) => ServiceJob.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <ServiceJob>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil data service job: $e');
    }
  }

  // GET /api/v1/service-jobs/:id
  Future<ApiResponse<ServiceJob>> getServiceJobById(String id) async {
    try {
      return await _apiService.get<ServiceJob>(
        '/service-jobs/$id',
        fromJson: (data) => ServiceJob.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil detail service job: $e');
    }
  }

  // POST /api/v1/service-jobs
  Future<ApiResponse<ServiceJob>> createServiceJob(
      ServiceJob serviceJob) async {
    try {
      return await _apiService.post<ServiceJob>(
        '/service-jobs',
        data: {
          'service_code': serviceJob.serviceCode,
          'customer_id': int.parse(serviceJob.customerId),
          'vehicle_id': int.parse(serviceJob.vehicleId),
          'user_id': int.parse(serviceJob.userId),
          'outlet_id': int.parse(serviceJob.outletId),
          'service_date': serviceJob.serviceDate.toIso8601String(),
          'complaint': serviceJob.complaint,
          'diagnosis': serviceJob.diagnosis,
          'estimated_cost': serviceJob.estimatedCost,
          'status': serviceJob.status,
          'notes': serviceJob.notes,
        },
        fromJson: (data) => ServiceJob.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal membuat service job: $e');
    }
  }

  // PUT /api/v1/service-jobs/:id
  Future<ApiResponse<ServiceJob>> updateServiceJob(
      String id, ServiceJob serviceJob) async {
    try {
      return await _apiService.put<ServiceJob>(
        '/service-jobs/$id',
        data: {
          'diagnosis': serviceJob.diagnosis,
          'actual_cost': serviceJob.actualCost,
          'notes': serviceJob.notes,
        },
        fromJson: (data) => ServiceJob.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal memperbarui service job: $e');
    }
  }

  // PUT /api/v1/service-jobs/:id/status
  Future<ApiResponse<ServiceJob>> updateServiceJobStatus(
      String id, String status, String? statusNotes) async {
    try {
      return await _apiService.put<ServiceJob>(
        '/service-jobs/$id/status',
        data: {
          'status': status,
          'status_notes': statusNotes,
        },
        fromJson: (data) => ServiceJob.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal memperbarui status service job: $e');
    }
  }

  // DELETE /api/v1/service-jobs/:id
  Future<ApiResponse<void>> deleteServiceJob(String id) async {
    try {
      return await _apiService.delete<void>(
        '/service-jobs/$id',
        fromJson: (_) => null,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal menghapus service job: $e');
    }
  }

  // GET /api/v1/service-jobs/status
  Future<ApiResponse<List<ServiceJob>>> getServiceJobsByStatus(
    String status, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'status': status,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      return await _apiService.get<List<ServiceJob>>(
        '/service-jobs/status',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map(
                    (json) => ServiceJob.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <ServiceJob>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil service job by status: $e');
    }
  }

  // GET /api/v1/service-jobs/service-code
  Future<ApiResponse<ServiceJob>> getServiceJobByCode(
      String serviceCode) async {
    try {
      final queryParams = {
        'service_code': serviceCode,
      };

      return await _apiService.get<ServiceJob>(
        '/service-jobs/service-code',
        queryParameters: queryParams,
        fromJson: (data) => ServiceJob.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil service job by code: $e');
    }
  }

  // GET /api/v1/customers/:customer_id/service-jobs
  Future<ApiResponse<List<ServiceJob>>> getServiceJobsByCustomer(
    String customerId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      return await _apiService.get<List<ServiceJob>>(
        '/customers/$customerId/service-jobs',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map(
                    (json) => ServiceJob.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <ServiceJob>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil service job by customer: $e');
    }
  }

  // Generate next service code
  Future<ApiResponse<Map<String, dynamic>>> getNextServiceCode() async {
    try {
      // This would be handled by backend, but we'll generate one for now
      final now = DateTime.now();
      final year = now.year;
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');
      final hour = now.hour.toString().padLeft(2, '0');
      final minute = now.minute.toString().padLeft(2, '0');

      final serviceCode = 'SJ-$year$month$day-$hour$minute';

      return ApiResponse<Map<String, dynamic>>(
        success: true,
        message: 'Service code generated',
        data: {'service_code': serviceCode},
      );
    } catch (e) {
      throw ApiException('Gagal generate service code: $e');
    }
  }
}
