import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/core/repositories/service_job_repository.dart';
import 'package:pos_bengkel/shared/models/service_job.dart';

class ServiceJobProvider extends ChangeNotifier {
  final ServiceJobRepository _repository;

  List<ServiceJob> _serviceJobs = [];
  List<ServiceJob> _searchResults = [];
  ServiceJob? _selectedServiceJob;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedStatus = 'Semua';
  String _nextServiceCode = '';

  // Getters
  List<ServiceJob> get serviceJobs => _serviceJobs;
  List<ServiceJob> get searchResults => _searchResults;
  ServiceJob? get selectedServiceJob => _selectedServiceJob;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;
  String get nextServiceCode => _nextServiceCode;

  ServiceJobProvider({ServiceJobRepository? repository})
      : _repository = repository ?? ServiceJobRepository();

  Future<void> loadServiceJobs({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
  }) async {
    try {
      if (page == 1) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
      }

      final response = await _repository.getServiceJobs(
        page: page,
        limit: limit,
        search: search,
        status: status != 'Semua' ? status : null,
      );

      if (response.success) {
        if (page == 1) {
          _serviceJobs = response.data ?? [];
        } else {
          _serviceJobs.addAll(response.data ?? []);
        }
        _errorMessage = null;
        debugPrint('✅ Loaded ${_serviceJobs.length} service jobs');
      } else {
        _errorMessage = response.message;
        debugPrint('❌ Failed to load service jobs: ${response.message}');
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('❌ Error loading service jobs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextServiceCode() async {
    try {
      final response = await _repository.getNextServiceCode();

      if (response.success && response.data != null) {
        _nextServiceCode = response.data!['service_code']?.toString() ?? '';
        debugPrint('✅ Next service code: $_nextServiceCode');
      } else {
        debugPrint('❌ Failed to get next service code');
      }
    } catch (e) {
      debugPrint('❌ Error getting next service code: $e');
    }
    notifyListeners();
  }

  Future<bool> createServiceJob(ServiceJob serviceJob) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.createServiceJob(serviceJob);

      if (response.success) {
        _serviceJobs.insert(0, response.data!);
        _errorMessage = null;
        // Update service code for next use
        await loadNextServiceCode();
        _isLoading = false;
        notifyListeners();
        debugPrint('✅ Service job created successfully');
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        debugPrint('❌ Failed to create service job: ${response.message}');
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ Error creating service job: $e');
      return false;
    }
  }

  Future<bool> updateServiceJob(String id, ServiceJob serviceJob) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.updateServiceJob(id, serviceJob);

      if (response.success) {
        final index = _serviceJobs.indexWhere((j) => j.serviceJobId == id);
        if (index != -1) {
          _serviceJobs[index] = response.data!;
        }
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateServiceJobStatus(
      String id, String status, String? statusNotes) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response =
          await _repository.updateServiceJobStatus(id, status, statusNotes);

      if (response.success) {
        final index = _serviceJobs.indexWhere((j) => j.serviceJobId == id);
        if (index != -1) {
          _serviceJobs[index] = response.data!;
        }
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteServiceJob(String id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.deleteServiceJob(id);

      if (response.success) {
        _serviceJobs.removeWhere((j) => j.serviceJobId == id);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    loadServiceJobs(status: status);
    notifyListeners();
  }

  void selectServiceJob(ServiceJob? serviceJob) {
    _selectedServiceJob = serviceJob;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
