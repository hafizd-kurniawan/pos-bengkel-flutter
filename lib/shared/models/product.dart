class Product {
  final String? productId;
  final String name;
  final String? description;
  final double costPrice;
  final double sellingPrice;
  final int stock;
  final String? sku;
  final String? barcode;
  final bool hasSerialNumber;
  final String? shelfLocation;
  final String usageStatus;
  final bool isActive;
  final String? categoryId;
  final String? supplierId;
  final String? unitTypeId;
  final Category? category;
  final Supplier? supplier;
  final UnitType? unitType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.productId,
    required this.name,
    this.description,
    required this.costPrice,
    required this.sellingPrice,
    required this.stock,
    this.sku,
    this.barcode,
    required this.hasSerialNumber,
    this.shelfLocation,
    required this.usageStatus,
    required this.isActive,
    this.categoryId,
    this.supplierId,
    this.unitTypeId,
    this.category,
    this.supplier,
    this.unitType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id']?.toString(),
      name: json['product_name'] ?? json['name'] ?? '',
      description: json['product_description'] ?? json['description'],
      costPrice: double.tryParse(json['cost_price']?.toString() ?? '0') ?? 0.0,
      sellingPrice:
          double.tryParse(json['selling_price']?.toString() ?? '0') ?? 0.0,
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      sku: json['sku'],
      barcode: json['barcode'],
      hasSerialNumber:
          json['has_serial_number'] == true || json['has_serial_number'] == 1,
      shelfLocation: json['shelf_location'],
      usageStatus: json['usage_status'] ?? 'Jual',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      categoryId: json['category_id']?.toString(),
      supplierId: json['supplier_id']?.toString(),
      unitTypeId: json['unit_type_id']?.toString(),
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      supplier:
          json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
      unitType: json['unit_type'] != null
          ? UnitType.fromJson(json['unit_type'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': name,
      'product_description': description,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'stock': stock,
      'sku': sku,
      'barcode': barcode,
      'has_serial_number': hasSerialNumber,
      'shelf_location': shelfLocation,
      'usage_status': usageStatus,
      'is_active': isActive,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'unit_type_id': unitTypeId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? productId,
    String? name,
    String? description,
    double? costPrice,
    double? sellingPrice,
    int? stock,
    String? sku,
    String? barcode,
    bool? hasSerialNumber,
    String? shelfLocation,
    String? usageStatus,
    bool? isActive,
    String? categoryId,
    String? supplierId,
    String? unitTypeId,
    Category? category,
    Supplier? supplier,
    UnitType? unitType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      hasSerialNumber: hasSerialNumber ?? this.hasSerialNumber,
      shelfLocation: shelfLocation ?? this.shelfLocation,
      usageStatus: usageStatus ?? this.usageStatus,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      unitTypeId: unitTypeId ?? this.unitTypeId,
      category: category ?? this.category,
      supplier: supplier ?? this.supplier,
      unitType: unitType ?? this.unitType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isInStock => stock > 0;

  // Untuk compatibility dengan UI yang sudah ada
  double get price => sellingPrice;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}

class Category {
  final String? categoryId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    this.categoryId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id']?.toString(),
      name: json['name'] ?? '',
      status: json['status'] ?? 'Aktif',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class UnitType {
  final String? unitTypeId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UnitType({
    this.unitTypeId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnitType.fromJson(Map<String, dynamic> json) {
    return UnitType(
      unitTypeId: json['unit_type_id']?.toString(),
      name: json['name'] ?? '',
      status: json['status'] ?? 'Aktif',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class Supplier {
  final String? supplierId;
  final String name;
  final String? contactPersonName;
  final String? phoneNumber;
  final String? address;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Supplier({
    this.supplierId,
    required this.name,
    this.contactPersonName,
    this.phoneNumber,
    this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierId: json['supplier_id']?.toString(),
      name: json['supplier_name'] ?? json['name'] ?? '',
      contactPersonName: json['contact_person_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      status: json['status'] ?? 'Aktif',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
