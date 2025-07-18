import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';
import 'package:pos_bengkel/shared/models/product.dart';
import 'package:pos_bengkel/features/master/models/service.dart';
import 'package:pos_bengkel/features/master/models/price_list.dart';

enum LoadingState { idle, loading, success, error }

class MasterDataProvider extends ChangeNotifier {
  // Products
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  LoadingState _productsState = LoadingState.idle;
  String? _productsError;

  // Customers
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  LoadingState _customersState = LoadingState.idle;
  String? _customersError;

  // Vehicles
  List<CustomerVehicle> _vehicles = [];
  List<CustomerVehicle> _filteredVehicles = [];
  LoadingState _vehiclesState = LoadingState.idle;
  String? _vehiclesError;

  // Services
  List<Service> _services = [];
  List<Service> _filteredServices = [];
  LoadingState _servicesState = LoadingState.idle;
  String? _servicesError;

  // Service Categories
  List<ServiceCategory> _serviceCategories = [];
  List<ServiceCategory> _filteredServiceCategories = [];
  LoadingState _serviceCategoriesState = LoadingState.idle;
  String? _serviceCategoriesError;

  // Price Lists
  List<PriceList> _priceLists = [];
  List<PriceList> _filteredPriceLists = [];
  LoadingState _priceListsState = LoadingState.idle;
  String? _priceListsError;

  // Pagination
  int _currentPage = 1;
  int _itemsPerPage = 25;
  int _totalItems = 0;

  // Search and Filter
  String _searchQuery = '';
  List<String> _activeFilters = [];

  // Getters
  List<Product> get products => _filteredProducts;
  List<Customer> get customers => _filteredCustomers;
  List<CustomerVehicle> get vehicles => _filteredVehicles;
  List<Service> get services => _filteredServices;
  List<ServiceCategory> get serviceCategories => _filteredServiceCategories;
  List<PriceList> get priceLists => _filteredPriceLists;

  LoadingState get productsState => _productsState;
  LoadingState get customersState => _customersState;
  LoadingState get vehiclesState => _vehiclesState;
  LoadingState get servicesState => _servicesState;
  LoadingState get serviceCategoriesState => _serviceCategoriesState;
  LoadingState get priceListsState => _priceListsState;

  String? get productsError => _productsError;
  String? get customersError => _customersError;
  String? get vehiclesError => _vehiclesError;
  String? get servicesError => _servicesError;
  String? get serviceCategoriesError => _serviceCategoriesError;
  String? get priceListsError => _priceListsError;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();
  String get searchQuery => _searchQuery;
  List<String> get activeFilters => List.unmodifiable(_activeFilters);

  bool get hasNextPage => _currentPage < totalPages;
  bool get hasPreviousPage => _currentPage > 1;

  // Products Methods
  Future<void> loadProducts() async {
    _productsState = LoadingState.loading;
    _productsError = null;
    notifyListeners();

    try {
      // Simulate API call - Replace with actual API integration
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for development
      _products = _generateMockProducts();
      _totalItems = _products.length;
      _applyProductFilters();
      
      _productsState = LoadingState.success;
    } catch (e) {
      _productsError = e.toString();
      _productsState = LoadingState.error;
    }
    
    notifyListeners();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyProductFilters();
    notifyListeners();
  }

  void filterProducts(List<String> filters) {
    _activeFilters = filters;
    _currentPage = 1;
    _applyProductFilters();
    notifyListeners();
  }

  void _applyProductFilters() {
    var filtered = List<Product>.from(_products);

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (product.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    // Apply filters
    for (String filter in _activeFilters) {
      switch (filter) {
        case 'in_stock':
          filtered = filtered.where((p) => p.isInStock).toList();
          break;
        case 'out_of_stock':
          filtered = filtered.where((p) => !p.isInStock).toList();
          break;
        case 'active':
          filtered = filtered.where((p) => p.isActive).toList();
          break;
        case 'inactive':
          filtered = filtered.where((p) => !p.isActive).toList();
          break;
      }
    }

    _totalItems = filtered.length;
    
    // Apply pagination
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    
    _filteredProducts = filtered.sublist(startIndex, endIndex);
  }

  // Customers Methods
  Future<void> loadCustomers() async {
    _customersState = LoadingState.loading;
    _customersError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _customers = _generateMockCustomers();
      _totalItems = _customers.length;
      _applyCustomerFilters();
      _customersState = LoadingState.success;
    } catch (e) {
      _customersError = e.toString();
      _customersState = LoadingState.error;
    }
    
    notifyListeners();
  }

  void searchCustomers(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyCustomerFilters();
    notifyListeners();
  }

  void _applyCustomerFilters() {
    var filtered = List<Customer>.from(_customers);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) =>
          customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          customer.phoneNumber.contains(_searchQuery) ||
          (customer.address?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    _totalItems = filtered.length;
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    
    _filteredCustomers = filtered.sublist(startIndex, endIndex);
  }

  // Vehicles Methods
  Future<void> loadVehicles() async {
    _vehiclesState = LoadingState.loading;
    _vehiclesError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _vehicles = _generateMockVehicles();
      _totalItems = _vehicles.length;
      _applyVehicleFilters();
      _vehiclesState = LoadingState.success;
    } catch (e) {
      _vehiclesError = e.toString();
      _vehiclesState = LoadingState.error;
    }
    
    notifyListeners();
  }

  void searchVehicles(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyVehicleFilters();
    notifyListeners();
  }

  void _applyVehicleFilters() {
    var filtered = List<CustomerVehicle>.from(_vehicles);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((vehicle) =>
          vehicle.plateNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.model.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    _totalItems = filtered.length;
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    
    _filteredVehicles = filtered.sublist(startIndex, endIndex);
  }

  // Services Methods
  Future<void> loadServices() async {
    _servicesState = LoadingState.loading;
    _servicesError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _services = _generateMockServices();
      _totalItems = _services.length;
      _applyServiceFilters();
      _servicesState = LoadingState.success;
    } catch (e) {
      _servicesError = e.toString();
      _servicesState = LoadingState.error;
    }
    
    notifyListeners();
  }

  void searchServices(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyServiceFilters();
    notifyListeners();
  }

  void _applyServiceFilters() {
    var filtered = List<Service>.from(_services);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((service) =>
          service.serviceName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (service.serviceDescription?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    _totalItems = filtered.length;
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    
    _filteredServices = filtered.sublist(startIndex, endIndex);
  }

  // Service Categories Methods
  Future<void> loadServiceCategories() async {
    _serviceCategoriesState = LoadingState.loading;
    _serviceCategoriesError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _serviceCategories = _generateMockServiceCategories();
      _totalItems = _serviceCategories.length;
      _applyServiceCategoryFilters();
      _serviceCategoriesState = LoadingState.success;
    } catch (e) {
      _serviceCategoriesError = e.toString();
      _serviceCategoriesState = LoadingState.error;
    }
    
    notifyListeners();
  }

  void searchServiceCategories(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyServiceCategoryFilters();
    notifyListeners();
  }

  void _applyServiceCategoryFilters() {
    var filtered = List<ServiceCategory>.from(_serviceCategories);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((category) =>
          category.categoryName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (category.categoryDescription?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    _totalItems = filtered.length;
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    
    _filteredServiceCategories = filtered.sublist(startIndex, endIndex);
  }

  // Price Lists Methods
  Future<void> loadPriceLists() async {
    _priceListsState = LoadingState.loading;
    _priceListsError = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      _priceLists = _generateMockPriceLists();
      _totalItems = _priceLists.length;
      _applyPriceListFilters();
      _priceListsState = LoadingState.success;
    } catch (e) {
      _priceListsError = e.toString();
      _priceListsState = LoadingState.error;
    }
    
    notifyListeners();
  }

  void searchPriceLists(String query) {
    _searchQuery = query;
    _currentPage = 1;
    _applyPriceListFilters();
    notifyListeners();
  }

  void _applyPriceListFilters() {
    var filtered = List<PriceList>.from(_priceLists);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((priceList) =>
          (priceList.service?.serviceName.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
      ).toList();
    }

    _totalItems = filtered.length;
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
    
    _filteredPriceLists = filtered.sublist(startIndex, endIndex);
  }

  // Pagination Methods
  void setPage(int page) {
    _currentPage = page.clamp(1, totalPages);
    _applyCurrentFilters();
    notifyListeners();
  }

  void setItemsPerPage(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1;
    _applyCurrentFilters();
    notifyListeners();
  }

  void nextPage() {
    if (hasNextPage) {
      setPage(_currentPage + 1);
    }
  }

  void previousPage() {
    if (hasPreviousPage) {
      setPage(_currentPage - 1);
    }
  }

  void _applyCurrentFilters() {
    // Apply the appropriate filter based on current data type
    if (_productsState == LoadingState.success) _applyProductFilters();
    if (_customersState == LoadingState.success) _applyCustomerFilters();
    if (_vehiclesState == LoadingState.success) _applyVehicleFilters();
    if (_servicesState == LoadingState.success) _applyServiceFilters();
    if (_serviceCategoriesState == LoadingState.success) _applyServiceCategoryFilters();
    if (_priceListsState == LoadingState.success) _applyPriceListFilters();
  }

  // Mock Data Generators (Replace with actual API calls)
  List<Product> _generateMockProducts() {
    return List.generate(50, (index) => Product(
      productId: 'PROD-${(index + 1).toString().padLeft(3, '0')}',
      name: 'Produk ${index + 1}',
      description: 'Deskripsi produk ${index + 1}',
      costPrice: 50000.0 + (index * 1000),
      sellingPrice: 75000.0 + (index * 1500),
      stock: (index % 10) + 1,
      sku: 'SKU-${index + 1}',
      hasSerialNumber: index % 3 == 0,
      usageStatus: 'Jual',
      isActive: index % 5 != 0,
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  List<Customer> _generateMockCustomers() {
    return List.generate(30, (index) => Customer(
      customerId: 'CUST-${(index + 1).toString().padLeft(3, '0')}',
      name: 'Customer ${index + 1}',
      phoneNumber: '081234567${(index + 1).toString().padLeft(2, '0')}',
      address: 'Alamat customer ${index + 1}',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  List<CustomerVehicle> _generateMockVehicles() {
    final brands = ['Toyota', 'Honda', 'Suzuki', 'Mitsubishi', 'Daihatsu'];
    final models = ['Avanza', 'Xenia', 'Jazz', 'Brio', 'Ertiga'];
    
    return List.generate(40, (index) => CustomerVehicle(
      vehicleId: 'VEH-${(index + 1).toString().padLeft(3, '0')}',
      customerId: 'CUST-${((index % 30) + 1).toString().padLeft(3, '0')}',
      plateNumber: 'B ${1000 + index} ABC',
      type: 'Mobil',
      brand: brands[index % brands.length],
      model: models[index % models.length],
      productionYear: 2015 + (index % 8),
      engineNumber: 'ENG-${index + 1}',
      chassisNumber: 'CHS-${index + 1}',
      color: 'Putih',
      status: 'Aktif',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  List<Service> _generateMockServices() {
    return List.generate(25, (index) => Service(
      serviceId: 'SRV-${(index + 1).toString().padLeft(3, '0')}',
      serviceName: 'Layanan ${index + 1}',
      serviceDescription: 'Deskripsi layanan ${index + 1}',
      serviceCost: 100000.0 + (index * 5000),
      status: 'Aktif',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  List<ServiceCategory> _generateMockServiceCategories() {
    return List.generate(15, (index) => ServiceCategory(
      serviceCategoryId: 'CAT-${(index + 1).toString().padLeft(2, '0')}',
      categoryName: 'Kategori ${index + 1}',
      categoryDescription: 'Deskripsi kategori ${index + 1}',
      status: 'Aktif',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }

  List<PriceList> _generateMockPriceLists() {
    return List.generate(20, (index) => PriceList(
      priceListId: 'PL-${(index + 1).toString().padLeft(3, '0')}',
      serviceId: 'SRV-${((index % 25) + 1).toString().padLeft(3, '0')}',
      price: 100000.0 + (index * 10000),
      effectiveDate: DateTime.now().subtract(Duration(days: index * 30)),
      status: 'Aktif',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      updatedAt: DateTime.now().subtract(Duration(days: index)),
    ));
  }
}