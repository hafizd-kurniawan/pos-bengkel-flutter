import 'customer.dart';
import 'user.dart';

class ServiceJob {
  final int serviceJobId;
  final String serviceCode;
  final int customerId;
  final int vehicleId;
  final int userId;
  final int outletId;
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
    required this.serviceJobId,
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
      serviceJobId: json['service_job_id'],
      serviceCode: json['service_code'],
      customerId: json['customer_id'],
      vehicleId: json['vehicle_id'],
      userId: json['user_id'],
      outletId: json['outlet_id'],
      serviceDate: DateTime.parse(json['service_date']),
      complaint: json['complaint'],
      diagnosis: json['diagnosis'],
      estimatedCost: (json['estimated_cost'] as num).toDouble(),
      actualCost: (json['actual_cost'] as num).toDouble(),
      status: json['status'],
      notes: json['notes'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      vehicle: json['vehicle'] != null ? CustomerVehicle.fromJson(json['vehicle']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      outlet: json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null,
      serviceDetails: json['service_details'] != null
          ? (json['service_details'] as List)
              .map((s) => ServiceDetail.fromJson(s))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'customer': customer?.toJson(),
      'vehicle': vehicle?.toJson(),
      'user': user?.toJson(),
      'outlet': outlet?.toJson(),
      'service_details': serviceDetails?.map((s) => s.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Service {
  final int serviceId;
  final String serviceCode;
  final String name;
  final int serviceCategoryId;
  final double fee;
  final String status;
  final ServiceCategory? serviceCategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.serviceId,
    required this.serviceCode,
    required this.name,
    required this.serviceCategoryId,
    required this.fee,
    required this.status,
    this.serviceCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id'],
      serviceCode: json['service_code'],
      name: json['name'],
      serviceCategoryId: json['service_category_id'],
      fee: (json['fee'] as num).toDouble(),
      status: json['status'],
      serviceCategory: json['service_category'] != null 
          ? ServiceCategory.fromJson(json['service_category']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_code': serviceCode,
      'name': name,
      'service_category_id': serviceCategoryId,
      'fee': fee,
      'status': status,
      'service_category': serviceCategory?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ServiceCategory {
  final int serviceCategoryId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceCategory({
    required this.serviceCategoryId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      serviceCategoryId: json['service_category_id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_category_id': serviceCategoryId,
      'name': name,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ServiceDetail {
  final int serviceDetailId;
  final int serviceJobId;
  final int serviceId;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double subtotal;
  final String? notes;
  final Service? service;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      serviceDetailId: json['service_detail_id'],
      serviceJobId: json['service_job_id'],
      serviceId: json['service_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      notes: json['notes'],
      service: json['service'] != null ? Service.fromJson(json['service']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_detail_id': serviceDetailId,
      'service_job_id': serviceJobId,
      'service_id': serviceId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount': discount,
      'subtotal': subtotal,
      'notes': notes,
      'service': service?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ServiceJobHistory {
  final int serviceJobHistoryId;
  final int serviceJobId;
  final int userId;
  final String statusFrom;
  final String statusTo;
  final String? notes;
  final DateTime changedAt;
  final User? user;

  ServiceJobHistory({
    required this.serviceJobHistoryId,
    required this.serviceJobId,
    required this.userId,
    required this.statusFrom,
    required this.statusTo,
    this.notes,
    required this.changedAt,
    this.user,
  });

  factory ServiceJobHistory.fromJson(Map<String, dynamic> json) {
    return ServiceJobHistory(
      serviceJobHistoryId: json['service_job_history_id'],
      serviceJobId: json['service_job_id'],
      userId: json['user_id'],
      statusFrom: json['status_from'],
      statusTo: json['status_to'],
      notes: json['notes'],
      changedAt: DateTime.parse(json['changed_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_job_history_id': serviceJobHistoryId,
      'service_job_id': serviceJobId,
      'user_id': userId,
      'status_from': statusFrom,
      'status_to': statusTo,
      'notes': notes,
      'changed_at': changedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}