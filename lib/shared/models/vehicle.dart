class Vehicle {
  final String? vehicleId;
  final String plateNumber;
  final String type;
  final String brand;
  final String model;
  final int productionYear;
  final String engineNumber;
  final String chassisNumber;
  final String color;
  final String condition;
  final String status; // 'available', 'sold', 'in_reconditioning', 'for_sale'
  final double? purchasePrice;
  final double? salePrice;
  final String? customerId; // Original owner when purchased
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    this.vehicleId,
    required this.plateNumber,
    required this.type,
    required this.brand,
    required this.model,
    required this.productionYear,
    required this.engineNumber,
    required this.chassisNumber,
    required this.color,
    required this.condition,
    required this.status,
    this.purchasePrice,
    this.salePrice,
    this.customerId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicle_id']?.toString(),
      plateNumber: json['plate_number'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      productionYear: int.tryParse(json['production_year']?.toString() ?? '') ?? 0,
      engineNumber: json['engine_number'] ?? '',
      chassisNumber: json['chassis_number'] ?? '',
      color: json['color'] ?? '',
      condition: json['condition'] ?? 'Baik',
      status: json['status'] ?? 'available',
      purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? ''),
      salePrice: double.tryParse(json['sale_price']?.toString() ?? ''),
      customerId: json['customer_id']?.toString(),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'plate_number': plateNumber,
      'type': type,
      'brand': brand,
      'model': model,
      'production_year': productionYear,
      'engine_number': engineNumber,
      'chassis_number': chassisNumber,
      'color': color,
      'condition': condition,
      'status': status,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'customer_id': customerId,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Vehicle copyWith({
    String? vehicleId,
    String? plateNumber,
    String? type,
    String? brand,
    String? model,
    int? productionYear,
    String? engineNumber,
    String? chassisNumber,
    String? color,
    String? condition,
    String? status,
    double? purchasePrice,
    double? salePrice,
    String? customerId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      vehicleId: vehicleId ?? this.vehicleId,
      plateNumber: plateNumber ?? this.plateNumber,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      productionYear: productionYear ?? this.productionYear,
      engineNumber: engineNumber ?? this.engineNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      color: color ?? this.color,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      customerId: customerId ?? this.customerId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => '$brand $model ($plateNumber)';
  String get fullInfo => '$brand $model $productionYear - $plateNumber';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId;

  @override
  int get hashCode => vehicleId.hashCode;
}