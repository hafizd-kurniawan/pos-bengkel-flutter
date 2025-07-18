import 'package:flutter/foundation.dart';
import '../../../core/api/service_job_repository.dart';
import '../../../core/api/customer_repository.dart';
import '../../../core/api/product_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/service.dart';
import '../../../shared/models/customer.dart';
import '../../../shared/models/product.dart';

class MekanikProvider extends ChangeNotifier {
  final ServiceJobRepository _serviceJobRepository = ServiceJobRepository();
  final ServiceDetailRepository _serviceDetailRepository = ServiceDetailRepository();
  final CustomerRepository _customerRepository = CustomerRepository();
  final CustomerVehicleRepository _vehicleRepository = CustomerVehicleRepository();
  final ProductRepository _productRepository = ProductRepository();

  List<ServiceJob> _serviceJobs = [];
  List<ServiceDetail> _serviceDetails = [];
  List<ServiceJobHistory> _serviceHistory = [];
  List<Customer> _customers = [];
  List<CustomerVehicle> _vehicles = [];
  List<Product> _products = [];
  ServiceJob? _selectedServiceJob;
  Customer? _selectedCustomer;
  CustomerVehicle? _selectedVehicle;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ServiceJob> get serviceJobs => _serviceJobs;
  List<ServiceDetail> get serviceDetails => _serviceDetails;
  List<ServiceJobHistory> get serviceHistory => _serviceHistory;
  List<Customer> get customers => _customers;
  List<CustomerVehicle> get vehicles => _vehicles;
  List<Product> get products => _products;
  ServiceJob? get selectedServiceJob => _selectedServiceJob;
  Customer? get selectedCustomer => _selectedCustomer;
  CustomerVehicle? get selectedVehicle => _selectedVehicle;
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

  // Load service jobs assigned to mekanik (filter by user_id in backend)
  Future<void> loadMyServiceJobs({
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
      _setError('Gagal memuat pekerjaan servis: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update service job diagnosis and notes
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
          if (_selectedServiceJob?.serviceJobId == id) {
            _selectedServiceJob = response.data!;
          }
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

  // Update service job status (main function for mekanik)
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
          if (_selectedServiceJob?.serviceJobId == id) {
            _selectedServiceJob = response.data!;
          }
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Gagal memperbarui status pekerjaan: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Select service job and load its details
  void selectServiceJob(ServiceJob serviceJob) {
    _selectedServiceJob = serviceJob;
    loadServiceDetails(serviceJob.serviceJobId);
    loadServiceJobHistory(serviceJob.serviceJobId);
    
    // Load customer and vehicle info
    if (serviceJob.customer != null) {
      _selectedCustomer = serviceJob.customer;
    }
    if (serviceJob.vehicle != null) {
      _selectedVehicle = serviceJob.vehicle;
    }
    
    notifyListeners();
  }

  // Clear selected service job
  void clearSelectedServiceJob() {
    _selectedServiceJob = null;
    _selectedCustomer = null;
    _selectedVehicle = null;
    _serviceDetails.clear();
    _serviceHistory.clear();
    notifyListeners();
  }

  // Load service details for current job
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

  // Add service detail to current job
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

  // Load customer info (read-only)
  Future<void> loadCustomer(int customerId) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _customerRepository.getCustomer(customerId);

      if (response.data != null) {
        _selectedCustomer = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat data pelanggan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load vehicle info (read-only)
  Future<void> loadVehicle(int vehicleId) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _vehicleRepository.getCustomerVehicle(vehicleId);

      if (response.data != null) {
        _selectedVehicle = response.data!;
      }
    } catch (e) {
      _setError('Gagal memuat data kendaraan: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load products for reference (read-only)
  Future<void> loadProducts({int page = 1, int limit = 10}) async {
    try {
      _setLoading(true);
      _setError(null);

      final response = await _productRepository.getProducts(
        page: page,
        limit: limit,
      );

      if (response.data != null) {
        if (page == 1) {
          _products = response.data!;
        } else {
          _products.addAll(response.data!);
        }
      }
    } catch (e) {
      _setError('Gagal memuat data produk: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      await loadProducts();
      return;
    }

    try {
      _setLoading(true);
      _setError(null);

      final response = await _productRepository.searchProducts(query: query);

      if (response.data != null) {
        _products = response.data!;
      }
    } catch (e) {
      _setError('Gagal mencari produk: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get service jobs by status
  List<ServiceJob> getServiceJobsByStatus(String status) {
    return _serviceJobs.where((job) => job.status == status).toList();
  }

  // Get pending service jobs
  List<ServiceJob> get pendingServiceJobs => 
      getServiceJobsByStatus(AppConstants.statusPending);

  // Get in progress service jobs (assigned to me)
  List<ServiceJob> get inProgressServiceJobs => 
      getServiceJobsByStatus(AppConstants.statusInProgress);

  // Get completed service jobs
  List<ServiceJob> get completedServiceJobs => 
      getServiceJobsByStatus(AppConstants.statusCompleted);

  // Calculate total for current service details
  double get currentServiceTotal {
    return _serviceDetails.fold(0.0, (sum, detail) => sum + detail.subtotal);
  }

  // Start working on a service job
  Future<bool> startServiceJob(int serviceJobId) async {
    return await updateServiceJobStatus(
      serviceJobId,
      AppConstants.statusInProgress,
      notes: 'Mekanik mulai mengerjakan servis',
    );
  }

  // Complete a service job
  Future<bool> completeServiceJob(int serviceJobId, {String? notes}) async {
    return await updateServiceJobStatus(
      serviceJobId,
      AppConstants.statusCompleted,
      notes: notes ?? 'Servis telah selesai dikerjakan',
    );
  }
}