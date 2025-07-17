class Customer {
  final int customerId;
  final String name;
  final String phoneNumber;
  final String? address;
  final String status;
  final List<CustomerVehicle>? vehicles;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.customerId,
    required this.name,
    required this.phoneNumber,
    this.address,
    required this.status,
    this.vehicles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      status: json['status'],
      vehicles: json['vehicles'] != null
          ? (json['vehicles'] as List)
              .map((v) => CustomerVehicle.fromJson(v))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'status': status,
      'vehicles': vehicles?.map((v) => v.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CustomerVehicle {
  final int vehicleId;
  final int customerId;
  final String plateNumber;
  final String brand;
  final String model;
  final String type;
  final int productionYear;
  final String chassisNumber;
  final String engineNumber;
  final String color;
  final String? notes;
  final Customer? customer;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerVehicle({
    required this.vehicleId,
    required this.customerId,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.type,
    required this.productionYear,
    required this.chassisNumber,
    required this.engineNumber,
    required this.color,
    this.notes,
    this.customer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerVehicle.fromJson(Map<String, dynamic> json) {
    return CustomerVehicle(
      vehicleId: json['vehicle_id'],
      customerId: json['customer_id'],
      plateNumber: json['plate_number'],
      brand: json['brand'],
      model: json['model'],
      type: json['type'],
      productionYear: json['production_year'],
      chassisNumber: json['chassis_number'],
      engineNumber: json['engine_number'],
      color: json['color'],
      notes: json['notes'],
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'customer_id': customerId,
      'plate_number': plateNumber,
      'brand': brand,
      'model': model,
      'type': type,
      'production_year': productionYear,
      'chassis_number': chassisNumber,
      'engine_number': engineNumber,
      'color': color,
      'notes': notes,
      'customer': customer?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}