import 'package:flutter/foundation.dart';
import 'package:pos_bengkel/features/master/widgets/data_export_dialog.dart';

class ExportProvider extends ChangeNotifier {
  bool _isExporting = false;
  String? _exportError;
  String? _lastExportedFile;

  bool get isExporting => _isExporting;
  String? get exportError => _exportError;
  String? get lastExportedFile => _lastExportedFile;

  Future<void> exportData({
    required ExportConfig config,
    required List<Map<String, dynamic>> data,
    String? customFileName,
  }) async {
    _isExporting = true;
    _exportError = null;
    notifyListeners();

    try {
      final fileName = customFileName ?? 
          '${config.fileName}${config.format.extension}';

      switch (config.format.value) {
        case 'csv':
          await _exportToCsv(data, fileName, config);
          break;
        case 'xlsx':
          await _exportToExcel(data, fileName, config);
          break;
        case 'pdf':
          await _exportToPdf(data, fileName, config);
          break;
        default:
          throw Exception('Format export tidak didukung: ${config.format.value}');
      }

      _lastExportedFile = fileName;
      _isExporting = false;
      notifyListeners();
    } catch (e) {
      _exportError = e.toString();
      _isExporting = false;
      notifyListeners();
    }
  }

  Future<void> _exportToCsv(
    List<Map<String, dynamic>> data,
    String fileName,
    ExportConfig config,
  ) async {
    // Simulate export process
    await Future.delayed(const Duration(seconds: 2));
    
    final csvContent = _generateCsvContent(data, config);
    
    // In a real implementation, you would save the file here
    // For web: use download_helper or similar
    // For mobile: use path_provider and file system
    
    if (kDebugMode) {
      print('CSV Export completed: $fileName');
      print('Content preview: ${csvContent.substring(0, csvContent.length.clamp(0, 200))}...');
    }
  }

  Future<void> _exportToExcel(
    List<Map<String, dynamic>> data,
    String fileName,
    ExportConfig config,
  ) async {
    // Simulate export process
    await Future.delayed(const Duration(seconds: 3));
    
    // In a real implementation, you would use excel package
    // Example: import 'package:excel/excel.dart';
    
    if (kDebugMode) {
      print('Excel Export completed: $fileName');
      print('Rows: ${data.length}');
    }
  }

  Future<void> _exportToPdf(
    List<Map<String, dynamic>> data,
    String fileName,
    ExportConfig config,
  ) async {
    // Simulate export process
    await Future.delayed(const Duration(seconds: 4));
    
    // In a real implementation, you would use pdf package
    // Example: import 'package:pdf/pdf.dart';
    
    if (kDebugMode) {
      print('PDF Export completed: $fileName');
      print('Rows: ${data.length}');
    }
  }

  String _generateCsvContent(
    List<Map<String, dynamic>> data,
    ExportConfig config,
  ) {
    if (data.isEmpty) return '';

    final buffer = StringBuffer();
    
    // Get field keys (either selected fields or all fields)
    final fieldKeys = config.selectedFields ?? data.first.keys.toList();
    
    // Add headers if requested
    if (config.includeHeaders) {
      buffer.writeln(fieldKeys.map(_escapeCsvField).join(','));
    }
    
    // Add data rows
    for (final row in data) {
      final values = fieldKeys.map((key) {
        final value = row[key];
        return _escapeCsvField(value?.toString() ?? '');
      });
      buffer.writeln(values.join(','));
    }
    
    return buffer.toString();
  }

  String _escapeCsvField(String field) {
    // Escape CSV field by wrapping in quotes if it contains comma, quote, or newline
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      // Escape existing quotes by doubling them
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }

  // Quick export methods for common data types
  Future<void> exportProducts({
    required List<Map<String, dynamic>> products,
    String? fileName,
  }) async {
    final config = ExportConfig(
      format: CommonExportOptions.csv,
      fileName: fileName ?? 'data_barang',
      includeHeaders: true,
      selectedFields: [
        'name',
        'sku',
        'category',
        'stock',
        'costPrice',
        'sellingPrice',
        'status',
      ],
    );

    await exportData(config: config, data: products);
  }

  Future<void> exportCustomers({
    required List<Map<String, dynamic>> customers,
    String? fileName,
  }) async {
    final config = ExportConfig(
      format: CommonExportOptions.csv,
      fileName: fileName ?? 'data_customer',
      includeHeaders: true,
      selectedFields: [
        'name',
        'phoneNumber',
        'address',
        'createdAt',
      ],
    );

    await exportData(config: config, data: customers);
  }

  Future<void> exportVehicles({
    required List<Map<String, dynamic>> vehicles,
    String? fileName,
  }) async {
    final config = ExportConfig(
      format: CommonExportOptions.csv,
      fileName: fileName ?? 'data_kendaraan',
      includeHeaders: true,
      selectedFields: [
        'plateNumber',
        'brand',
        'model',
        'productionYear',
        'color',
        'status',
      ],
    );

    await exportData(config: config, data: vehicles);
  }

  Future<void> exportServices({
    required List<Map<String, dynamic>> services,
    String? fileName,
  }) async {
    final config = ExportConfig(
      format: CommonExportOptions.csv,
      fileName: fileName ?? 'data_servis',
      includeHeaders: true,
      selectedFields: [
        'serviceName',
        'serviceDescription',
        'serviceCost',
        'category',
        'status',
      ],
    );

    await exportData(config: config, data: services);
  }

  Future<void> exportServiceCategories({
    required List<Map<String, dynamic>> categories,
    String? fileName,
  }) async {
    final config = ExportConfig(
      format: CommonExportOptions.csv,
      fileName: fileName ?? 'kategori_servis',
      includeHeaders: true,
      selectedFields: [
        'categoryName',
        'categoryDescription',
        'parentCategory',
        'status',
      ],
    );

    await exportData(config: config, data: categories);
  }

  Future<void> exportPriceLists({
    required List<Map<String, dynamic>> priceLists,
    String? fileName,
  }) async {
    final config = ExportConfig(
      format: CommonExportOptions.csv,
      fileName: fileName ?? 'daftar_harga',
      includeHeaders: true,
      selectedFields: [
        'serviceName',
        'price',
        'effectiveDate',
        'endDate',
        'status',
      ],
    );

    await exportData(config: config, data: priceLists);
  }

  void clearError() {
    _exportError = null;
    notifyListeners();
  }

  void clearLastExported() {
    _lastExportedFile = null;
    notifyListeners();
  }
}

// Extension to help convert objects to Map for export
extension ExportableData on Object {
  Map<String, dynamic> toExportMap() {
    // This would be implemented based on the specific object type
    // For now, return empty map as placeholder
    return {};
  }
}

// Helper class for export field definitions
class ExportFieldDefinitions {
  static const productFields = [
    ExportField(
      key: 'name',
      label: 'Nama Produk',
      description: 'Nama produk/spare part',
    ),
    ExportField(
      key: 'sku',
      label: 'SKU',
      description: 'Stock Keeping Unit',
    ),
    ExportField(
      key: 'category',
      label: 'Kategori',
      description: 'Kategori produk',
    ),
    ExportField(
      key: 'stock',
      label: 'Stok',
      description: 'Jumlah stok tersedia',
    ),
    ExportField(
      key: 'costPrice',
      label: 'Harga Beli',
      description: 'Harga pembelian dari supplier',
    ),
    ExportField(
      key: 'sellingPrice',
      label: 'Harga Jual',
      description: 'Harga jual ke customer',
    ),
    ExportField(
      key: 'status',
      label: 'Status',
      description: 'Status aktif/nonaktif',
    ),
  ];

  static const customerFields = [
    ExportField(
      key: 'name',
      label: 'Nama Customer',
      description: 'Nama lengkap customer',
    ),
    ExportField(
      key: 'phoneNumber',
      label: 'No. Telepon',
      description: 'Nomor telepon customer',
    ),
    ExportField(
      key: 'address',
      label: 'Alamat',
      description: 'Alamat lengkap customer',
      isSelectedByDefault: false,
    ),
    ExportField(
      key: 'createdAt',
      label: 'Tanggal Daftar',
      description: 'Tanggal pendaftaran customer',
    ),
  ];

  static const vehicleFields = [
    ExportField(
      key: 'plateNumber',
      label: 'Nomor Plat',
      description: 'Nomor polisi kendaraan',
    ),
    ExportField(
      key: 'brand',
      label: 'Merek',
      description: 'Merek kendaraan',
    ),
    ExportField(
      key: 'model',
      label: 'Model',
      description: 'Model kendaraan',
    ),
    ExportField(
      key: 'productionYear',
      label: 'Tahun',
      description: 'Tahun produksi',
    ),
    ExportField(
      key: 'color',
      label: 'Warna',
      description: 'Warna kendaraan',
    ),
    ExportField(
      key: 'status',
      label: 'Status',
      description: 'Status aktif/nonaktif',
    ),
  ];

  static const serviceFields = [
    ExportField(
      key: 'serviceName',
      label: 'Nama Layanan',
      description: 'Nama layanan servis',
    ),
    ExportField(
      key: 'serviceDescription',
      label: 'Deskripsi',
      description: 'Deskripsi layanan',
      isSelectedByDefault: false,
    ),
    ExportField(
      key: 'serviceCost',
      label: 'Harga',
      description: 'Harga layanan',
    ),
    ExportField(
      key: 'category',
      label: 'Kategori',
      description: 'Kategori layanan',
    ),
    ExportField(
      key: 'status',
      label: 'Status',
      description: 'Status aktif/nonaktif',
    ),
  ];

  static const serviceCategoryFields = [
    ExportField(
      key: 'categoryName',
      label: 'Nama Kategori',
      description: 'Nama kategori layanan',
    ),
    ExportField(
      key: 'categoryDescription',
      label: 'Deskripsi',
      description: 'Deskripsi kategori',
      isSelectedByDefault: false,
    ),
    ExportField(
      key: 'parentCategory',
      label: 'Kategori Induk',
      description: 'Kategori induk (jika ada)',
      isSelectedByDefault: false,
    ),
    ExportField(
      key: 'status',
      label: 'Status',
      description: 'Status aktif/nonaktif',
    ),
  ];

  static const priceListFields = [
    ExportField(
      key: 'serviceName',
      label: 'Nama Layanan',
      description: 'Nama layanan servis',
    ),
    ExportField(
      key: 'price',
      label: 'Harga',
      description: 'Harga layanan',
    ),
    ExportField(
      key: 'effectiveDate',
      label: 'Berlaku Dari',
      description: 'Tanggal mulai berlaku',
    ),
    ExportField(
      key: 'endDate',
      label: 'Berlaku Hingga',
      description: 'Tanggal berakhir (jika ada)',
      isSelectedByDefault: false,
    ),
    ExportField(
      key: 'status',
      label: 'Status',
      description: 'Status aktif/nonaktif',
    ),
  ];
}