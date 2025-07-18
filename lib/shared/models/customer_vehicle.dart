class CustomerVehicle {
  final String? vehicleId;
  final String customerId;
  final String plateNumber;
  final String type;
  final String brand;
  final String model;
  final int productionYear;
  final String engineNumber;
  final String chassisNumber;
  final String color;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerVehicle({
    this.vehicleId,
    required this.customerId,
    required this.plateNumber,
    required this.type,
    required this.brand,
    required this.model,
    required this.productionYear,
    required this.engineNumber,
    required this.chassisNumber,
    required this.color,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerVehicle.fromJson(Map<String, dynamic> json) {
    return CustomerVehicle(
      vehicleId: json['vehicle_id']?.toString(),
      customerId: json['customer_id']?.toString() ?? '',
      plateNumber: json['plate_number'] ?? '',
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      productionYear:
          int.tryParse(json['production_year']?.toString() ?? '') ?? 0,
      engineNumber: json['engine_number'] ?? '',
      chassisNumber: json['chassis_number'] ?? '',
      color: json['color'] ?? '',
      status: json['status'] ?? 'Aktif',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'customer_id': customerId,
      'plate_number': plateNumber,
      'type': type,
      'brand': brand,
      'model': model,
      'production_year': productionYear,
      'engine_number': engineNumber,
      'chassis_number': chassisNumber,
      'color': color,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CustomerVehicle copyWith({
    String? vehicleId,
    String? customerId,
    String? plateNumber,
    String? type,
    String? brand,
    String? model,
    int? productionYear,
    String? engineNumber,
    String? chassisNumber,
    String? color,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerVehicle(
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      plateNumber: plateNumber ?? this.plateNumber,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      productionYear: productionYear ?? this.productionYear,
      engineNumber: engineNumber ?? this.engineNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      color: color ?? this.color,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => '$brand $model ($plateNumber)';
  String get fullInfo => '$brand $model $productionYear - $plateNumber';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerVehicle &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId;

  @override
  int get hashCode => vehicleId.hashCode;
}
