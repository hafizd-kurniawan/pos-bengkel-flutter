import 'package:flutter/foundation.dart';
import '../../../core/api/service_job_repository.dart';
import '../../../core/api/service_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/service.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceRepository _serviceRepository = ServiceRepository();
  final ServiceJobRepository _serviceJobRepository = ServiceJobRepository();
  final ServiceDetailRepository _serviceDetailRepository = ServiceDetailRepository();

  List<Service> _services = [];
  List<ServiceJob> _serviceJobs = [];
  List<ServiceDetail> _serviceDetails = [];
  List<ServiceJobHistory> _serviceHistory = [];
  Service? _selectedService;
  ServiceJob? _selectedServiceJob;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Service> get services => _services;
  List<ServiceJob> get serviceJobs => _serviceJobs;
  List<ServiceDetail> get serviceDetails => _serviceDetails;
  List<ServiceJobHistory> get serviceHistory => _serviceHistory;
  Service? get selectedService => _selectedService;
  ServiceJob? get selectedServiceJob => _selectedServiceJob;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Load services
  Future<void> loadServices({int page = 1, int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceRepository.getServices(
        page: page,
        limit: limit,
      );

      if (response.data != null) {
        if (page == 1) {
          _services = response.data!;
        } else {
          _services.addAll(response.data!);
        }
      }
    } catch (e) {
      _setError('Gagal memuat data layanan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search services
  Future<void> searchServices(String query) async {
    if (query.isEmpty) {
      await loadServices();
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceRepository.searchServices(query: query);

      if (response.data != null) {
        _services = response.data!;
      }
    } catch (e) {
      _setError('Gagal mencari layanan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load service jobs
  Future<void> loadServiceJobs({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceJobRepository.getServiceJobs(
        page: page,
        limit: limit,
        status: status,
      );

      if (response.data != null) {
        if (page == 1) {
          _serviceJobs = response.data!;
        } else {
          _serviceJobs.addAll(response.data!);
        }
      }
    } catch (e) {
      _setError('Gagal memuat data pekerjaan servis: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create service job
  Future<bool> createServiceJob({
    required int customerId,
    required int vehicleId,
    required int userId,
    required int outletId,
    required DateTime serviceDate,
    required String complaint,
    String? diagnosis,
    required double estimatedCost,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceJobRepository.createServiceJob(
        customerId: customerId,
        vehicleId: vehicleId,
        userId: userId,
        outletId: outletId,
        serviceDate: serviceDate,
        complaint: complaint,
        diagnosis: diagnosis,
        estimatedCost: estimatedCost,
        notes: notes,
      );

      if (response.data != null) {
        _serviceJobs.insert(0, response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal membuat pekerjaan servis: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update service job
  Future<bool> updateServiceJob(
    int id, {
    String? diagnosis,
    double? actualCost,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceJobRepository.updateServiceJob(
        id,
        diagnosis: diagnosis,
        actualCost: actualCost,
        notes: notes,
      );

      if (response.data != null) {
        final index = _serviceJobs.indexWhere((j) => j.serviceJobId == id);
        if (index != -1) {
          _serviceJobs[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui pekerjaan servis: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update service job status
  Future<bool> updateServiceJobStatus(
    int id,
    String status, {
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceJobRepository.updateServiceJobStatus(
        id,
        status,
        notes: notes,
      );

      if (response.data != null) {
        final index = _serviceJobs.indexWhere((j) => j.serviceJobId == id);
        if (index != -1) {
          _serviceJobs[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui status pekerjaan servis: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select service job
  void selectServiceJob(ServiceJob serviceJob) {
    _selectedServiceJob = serviceJob;
    loadServiceDetails(serviceJob.serviceJobId);
    loadServiceJobHistory(serviceJob.serviceJobId);
    notifyListeners();
  }

  // Clear selected service job
  void clearSelectedServiceJob() {
    _selectedServiceJob = null;
    _serviceDetails.clear();
    _serviceHistory.clear();
    notifyListeners();
  }

  // Load service details
  Future<void> loadServiceDetails(int serviceJobId) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceDetailRepository.getServiceDetails(serviceJobId);

      if (response.data != null) {
        _serviceDetails = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat detail servis: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Create service detail
  Future<bool> createServiceDetail({
    required int serviceJobId,
    required int serviceId,
    required int quantity,
    required double unitPrice,
    double discount = 0,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceDetailRepository.createServiceDetail(
        serviceJobId: serviceJobId,
        serviceId: serviceId,
        quantity: quantity,
        unitPrice: unitPrice,
        discount: discount,
        notes: notes,
      );

      if (response.data != null) {
        _serviceDetails.insert(0, response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal menambah detail servis: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update service detail
  Future<bool> updateServiceDetail(
    int id, {
    int? quantity,
    double? unitPrice,
    double? discount,
    String? notes,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceDetailRepository.updateServiceDetail(
        id,
        quantity: quantity,
        unitPrice: unitPrice,
        discount: discount,
        notes: notes,
      );

      if (response.data != null) {
        final index = _serviceDetails.indexWhere((d) => d.serviceDetailId == id);
        if (index != -1) {
          _serviceDetails[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui detail servis: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete service detail
  Future<bool> deleteServiceDetail(int id) async {
    try {
      _setLoading(true);
      _setError(null);

      await _serviceDetailRepository.deleteServiceDetail(id);
      _serviceDetails.removeWhere((d) => d.serviceDetailId == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Gagal menghapus detail servis: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load service job history
  Future<void> loadServiceJobHistory(int serviceJobId) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _serviceJobRepository.getServiceJobHistory(serviceJobId);

      if (response.data != null) {
        _serviceHistory = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat riwayat pekerjaan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Select service
  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }

  // Clear selected service
  void clearSelectedService() {
    _selectedService = null;
    notifyListeners();
  }

  // Get service jobs by status
  List<ServiceJob> getServiceJobsByStatus(String status) {
    return _serviceJobs.where((job) => job.status == status).toList();
  }

  // Get pending service jobs
  List<ServiceJob> get pendingServiceJobs => 
      getServiceJobsByStatus(AppConstants.statusPending);

  // Get in progress service jobs
  List<ServiceJob> get inProgressServiceJobs => 
      getServiceJobsByStatus(AppConstants.statusInProgress);

  // Get completed service jobs
  List<ServiceJob> get completedServiceJobs => 
      getServiceJobsByStatus(AppConstants.statusCompleted);
}