class Product {
  final int productId;
  final String productName;
  final String sku;
  final String? barcode;
  final int categoryId;
  final int supplierId;
  final int unitTypeId;
  final double purchasePrice;
  final double sellingPrice;
  final int stock;
  final int minStock;
  final String status;
  final String? description;
  final Category? category;
  final Supplier? supplier;
  final UnitType? unitType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.productId,
    required this.productName,
    required this.sku,
    this.barcode,
    required this.categoryId,
    required this.supplierId,
    required this.unitTypeId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    required this.minStock,
    required this.status,
    this.description,
    this.category,
    this.supplier,
    this.unitType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      sku: json['sku'],
      barcode: json['barcode'],
      categoryId: json['category_id'],
      supplierId: json['supplier_id'],
      unitTypeId: json['unit_type_id'],
      purchasePrice: (json['purchase_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      stock: json['stock'],
      minStock: json['min_stock'],
      status: json['status'],
      description: json['description'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      supplier: json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
      unitType: json['unit_type'] != null ? UnitType.fromJson(json['unit_type']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'unit_type_id': unitTypeId,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'stock': stock,
      'min_stock': minStock,
      'status': status,
      'description': description,
      'category': category?.toJson(),
      'supplier': supplier?.toJson(),
      'unit_type': unitType?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Category {
  final int categoryId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.categoryId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Supplier {
  final int supplierId;
  final String supplierName;
  final String contactPersonName;
  final String phoneNumber;
  final String address;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Supplier({
    required this.supplierId,
    required this.supplierName,
    required this.contactPersonName,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      supplierId: json['supplier_id'],
      supplierName: json['supplier_name'],
      contactPersonName: json['contact_person_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplier_id': supplierId,
      'supplier_name': supplierName,
      'contact_person_name': contactPersonName,
      'phone_number': phoneNumber,
      'address': address,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class UnitType {
  final int unitTypeId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UnitType({
    required this.unitTypeId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnitType.fromJson(Map<String, dynamic> json) {
    return UnitType(
      unitTypeId: json['unit_type_id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unit_type_id': unitTypeId,
      'name': name,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}