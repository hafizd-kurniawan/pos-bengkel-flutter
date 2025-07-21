import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/shared/models/reconditioning.dart';
import 'package:pos_bengkel/shared/models/vehicle.dart';
import 'package:pos_bengkel/core/services/api_service.dart';

class ReconditioningProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Current form data
  String? _selectedVehicleId;
  String _description = '';
  double _estimatedCost = 0.0;
  String _notes = '';
  String _invoiceNumber = '';

  // Detail form data
  String _itemName = '';
  String _itemType = 'parts';
  int _quantity = 1;
  double _unitPrice = 0.0;

  // Data lists
  List<ReconditioningJob> _jobs = [];
  List<ReconditioningDetail> _jobDetails = [];
  List<Vehicle> _availableVehicles = [];
  ReconditioningJob? _currentJob;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get selectedVehicleId => _selectedVehicleId;
  String get description => _description;
  double get estimatedCost => _estimatedCost;
  String get notes => _notes;
  String get invoiceNumber => _invoiceNumber;
  String get itemName => _itemName;
  String get itemType => _itemType;
  int get quantity => _quantity;
  double get unitPrice => _unitPrice;
  
  List<ReconditioningJob> get jobs => _jobs;
  List<ReconditioningDetail> get jobDetails => _jobDetails;
  List<Vehicle> get availableVehicles => _availableVehicles;
  ReconditioningJob? get currentJob => _currentJob;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get canCreateJob => 
      _selectedVehicleId != null &&
      _description.isNotEmpty &&
      _estimatedCost > 0;

  bool get canAddDetail =>
      _itemName.isNotEmpty &&
      _quantity > 0 &&
      _unitPrice >= 0;

  double get totalDetailPrice => _quantity * _unitPrice;

  ReconditioningProvider() {
    _generateInvoiceNumber();
    loadAvailableVehicles();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd-HHmmss');
    _invoiceNumber = 'RC-${formatter.format(now)}';
  }

  // Form setters
  void setSelectedVehicleId(String? vehicleId) {
    _selectedVehicleId = vehicleId;
    notifyListeners();
  }

  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  void setEstimatedCost(double cost) {
    _estimatedCost = cost;
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  void setItemName(String name) {
    _itemName = name;
    notifyListeners();
  }

  void setItemType(String type) {
    _itemType = type;
    notifyListeners();
  }

  void setQuantity(int qty) {
    _quantity = qty;
    notifyListeners();
  }

  void setUnitPrice(double price) {
    _unitPrice = price;
    notifyListeners();
  }

  void clearJobForm() {
    _selectedVehicleId = null;
    _description = '';
    _estimatedCost = 0.0;
    _notes = '';
    _generateInvoiceNumber();
    notifyListeners();
  }

  void clearDetailForm() {
    _itemName = '';
    _itemType = 'parts';
    _quantity = 1;
    _unitPrice = 0.0;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // API Methods

  /// POST /api/v1/vehicles/reconditioning - Create reconditioning job
  Future<bool> createReconditioningJob() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final jobData = {
        'vehicle_id': _selectedVehicleId,
        'invoice_number': _invoiceNumber,
        'description': _description,
        'estimated_cost': _estimatedCost,
        'notes': _notes,
      };

      final response = await _apiService.post<ReconditioningJob>(
        '/vehicles/reconditioning',
        data: jobData,
        fromJson: (json) => ReconditioningJob.fromJson(json),
      );

      if (response.success && response.data != null) {
        _jobs.insert(0, response.data!);
        _currentJob = response.data!;
        clearJobForm();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// GET /api/v1/vehicles/reconditioning/jobs/:id - Get reconditioning job by ID
  Future<ReconditioningJob?> getReconditioningJobById(String jobId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<ReconditioningJob>(
        '/vehicles/reconditioning/jobs/$jobId',
        fromJson: (json) => ReconditioningJob.fromJson(json),
      );

      _isLoading = false;
      notifyListeners();

      if (response.success && response.data != null) {
        _currentJob = response.data!;
        return response.data;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// GET /api/v1/vehicles/reconditioning/vehicle/:vehicle_id - Get reconditioning jobs by vehicle ID
  Future<void> loadReconditioningJobsByVehicle(String vehicleId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<ReconditioningJob>>(
        '/vehicles/reconditioning/vehicle/$vehicleId',
        fromJson: (json) => (json as List)
            .map((item) => ReconditioningJob.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _jobs = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// POST /api/v1/vehicles/reconditioning/details - Add reconditioning detail
  Future<bool> addReconditioningDetail(String jobId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final detailData = {
        'job_id': jobId,
        'item_name': _itemName,
        'item_type': _itemType,
        'quantity': _quantity,
        'unit_price': _unitPrice,
        'total_price': totalDetailPrice,
      };

      final response = await _apiService.post<ReconditioningDetail>(
        '/vehicles/reconditioning/details',
        data: detailData,
        fromJson: (json) => ReconditioningDetail.fromJson(json),
      );

      if (response.success && response.data != null) {
        _jobDetails.add(response.data!);
        clearDetailForm();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// GET /api/v1/vehicles/reconditioning/details/job/:job_id - Get reconditioning details by job ID
  Future<void> loadReconditioningDetailsByJob(String jobId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<ReconditioningDetail>>(
        '/vehicles/reconditioning/details/job/$jobId',
        fromJson: (json) => (json as List)
            .map((item) => ReconditioningDetail.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _jobDetails = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// PUT /api/v1/vehicles/reconditioning/jobs/:id/complete - Complete reconditioning job
  Future<bool> completeReconditioningJob(String jobId, {double? actualCost}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final completeData = actualCost != null
          ? {'actual_cost': actualCost}
          : <String, dynamic>{};

      final response = await _apiService.put<ReconditioningJob>(
        '/vehicles/reconditioning/jobs/$jobId/complete',
        data: completeData,
        fromJson: (json) => ReconditioningJob.fromJson(json),
      );

      if (response.success && response.data != null) {
        // Update the job in the list
        final jobIndex = _jobs.indexWhere((job) => job.jobId == jobId);
        if (jobIndex != -1) {
          _jobs[jobIndex] = response.data!;
        }
        
        if (_currentJob?.jobId == jobId) {
          _currentJob = response.data!;
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Load all reconditioning jobs
  Future<void> loadAllReconditioningJobs() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiService.get<List<ReconditioningJob>>(
        '/vehicles/reconditioning/jobs',
        fromJson: (json) => (json as List)
            .map((item) => ReconditioningJob.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _jobs = response.data!;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load available vehicles for reconditioning
  Future<void> loadAvailableVehicles() async {
    try {
      final response = await _apiService.get<List<Vehicle>>(
        '/vehicles',
        queryParameters: {'status': 'available,in_reconditioning'},
        fromJson: (json) => (json as List)
            .map((item) => Vehicle.fromJson(item))
            .toList(),
      );

      if (response.success && response.data != null) {
        _availableVehicles = response.data!;
        notifyListeners();
      }
    } catch (e) {
      print('Error loading available vehicles: $e');
    }
  }
}