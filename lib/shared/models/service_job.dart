import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class ServiceJob {
  final String? serviceJobId;
  final String serviceCode;
  final String customerId;
  final String vehicleId;
  final String userId;
  final String outletId;
  final DateTime serviceDate;
  final String complaint;
  final String? diagnosis;
  final double estimatedCost;
  final double actualCost;
  final String status;
  final String? notes;
  final Customer? customer;
  final CustomerVehicle? vehicle;
  final User? user;
  final Outlet? outlet;
  final List<ServiceDetail>? serviceDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceJob({
    this.serviceJobId,
    required this.serviceCode,
    required this.customerId,
    required this.vehicleId,
    required this.userId,
    required this.outletId,
    required this.serviceDate,
    required this.complaint,
    this.diagnosis,
    required this.estimatedCost,
    required this.actualCost,
    required this.status,
    this.notes,
    this.customer,
    this.vehicle,
    this.user,
    this.outlet,
    this.serviceDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceJob.fromJson(Map<String, dynamic> json) {
    return ServiceJob(
      serviceJobId: json['service_job_id']?.toString(),
      serviceCode: json['service_code'] ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      vehicleId: json['vehicle_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      outletId: json['outlet_id']?.toString() ?? '',
      serviceDate:
          DateTime.tryParse(json['service_date'] ?? '') ?? DateTime.now(),
      complaint: json['complaint'] ?? '',
      diagnosis: json['diagnosis'],
      estimatedCost:
          double.tryParse(json['estimated_cost']?.toString() ?? '0') ?? 0.0,
      actualCost:
          double.tryParse(json['actual_cost']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'Pending',
      notes: json['notes'],
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      vehicle: json['vehicle'] != null
          ? CustomerVehicle.fromJson(json['vehicle'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      outlet: json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null,
      serviceDetails: json['service_details'] != null
          ? List<ServiceDetail>.from(
              json['service_details'].map((x) => ServiceDetail.fromJson(x)))
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_job_id': serviceJobId,
      'service_code': serviceCode,
      'customer_id': customerId,
      'vehicle_id': vehicleId,
      'user_id': userId,
      'outlet_id': outletId,
      'service_date': serviceDate.toIso8601String(),
      'complaint': complaint,
      'diagnosis': diagnosis,
      'estimated_cost': estimatedCost,
      'actual_cost': actualCost,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get vehicleInfo => vehicle?.displayName ?? 'Unknown Vehicle';
  String get customerName => customer?.name ?? 'Unknown Customer';
  String get plateNumber => vehicle?.plateNumber ?? 'Unknown';
  String get userName => user?.name ?? 'Unknown User';
  String get outletName => outlet?.outletName ?? 'Unknown Outlet';

  ServiceJob copyWith({
    String? serviceJobId,
    String? serviceCode,
    String? customerId,
    String? vehicleId,
    String? userId,
    String? outletId,
    DateTime? serviceDate,
    String? complaint,
    String? diagnosis,
    double? estimatedCost,
    double? actualCost,
    String? status,
    String? notes,
    Customer? customer,
    CustomerVehicle? vehicle,
    User? user,
    Outlet? outlet,
    List<ServiceDetail>? serviceDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceJob(
      serviceJobId: serviceJobId ?? this.serviceJobId,
      serviceCode: serviceCode ?? this.serviceCode,
      customerId: customerId ?? this.customerId,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      outletId: outletId ?? this.outletId,
      serviceDate: serviceDate ?? this.serviceDate,
      complaint: complaint ?? this.complaint,
      diagnosis: diagnosis ?? this.diagnosis,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      actualCost: actualCost ?? this.actualCost,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      customer: customer ?? this.customer,
      vehicle: vehicle ?? this.vehicle,
      user: user ?? this.user,
      outlet: outlet ?? this.outlet,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceJob &&
          runtimeType == other.runtimeType &&
          serviceJobId == other.serviceJobId;

  @override
  int get hashCode => serviceJobId.hashCode;
}

// Helper Models
class User {
  final String userId;
  final String name;
  final String? email;

  User({
    required this.userId,
    required this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'],
    );
  }
}

class Outlet {
  final String outletId;
  final String outletName;
  final String? city;

  Outlet({
    required this.outletId,
    required this.outletName,
    this.city,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      outletId: json['outlet_id']?.toString() ?? '',
      outletName: json['outlet_name'] ?? '',
      city: json['city'],
    );
  }
}

class ServiceDetail {
  final String serviceDetailId;
  final String serviceJobId;
  final String serviceId;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double subtotal;
  final String? notes;
  final Service? service;

  ServiceDetail({
    required this.serviceDetailId,
    required this.serviceJobId,
    required this.serviceId,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.subtotal,
    this.notes,
    this.service,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      serviceDetailId: json['service_detail_id']?.toString() ?? '',
      serviceJobId: json['service_job_id']?.toString() ?? '',
      serviceId: json['service_id']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      notes: json['notes'],
      service:
          json['service'] != null ? Service.fromJson(json['service']) : null,
    );
  }
}

class Service {
  final String serviceId;
  final String serviceCode;
  final String name;
  final double fee;
  final ServiceCategory? serviceCategory;

  Service({
    required this.serviceId,
    required this.serviceCode,
    required this.name,
    required this.fee,
    this.serviceCategory,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id']?.toString() ?? '',
      serviceCode: json['service_code'] ?? '',
      name: json['name'] ?? '',
      fee: double.tryParse(json['fee']?.toString() ?? '0') ?? 0.0,
      serviceCategory: json['service_category'] != null
          ? ServiceCategory.fromJson(json['service_category'])
          : null,
    );
  }
}

class ServiceCategory {
  final String serviceCategoryId;
  final String name;
  final String status;

  ServiceCategory({
    required this.serviceCategoryId,
    required this.name,
    required this.status,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      serviceCategoryId: json['service_category_id']?.toString() ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'Aktif',
    );
  }
}
