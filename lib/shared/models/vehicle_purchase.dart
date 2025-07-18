import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/customer_vehicle.dart';

class VehiclePurchase {
  final String? purchaseId;
  final String invoiceNumber;
  final String customerId;
  final String vehicleId;
  final double purchasePrice;
  final String condition;
  final String notes;
  final String purchaseDate;
  final String status;
  final String nextAction; // 'servis' atau 'jual'
  final Customer? customer;
  final CustomerVehicle? vehicle;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehiclePurchase({
    this.purchaseId,
    required this.invoiceNumber,
    required this.customerId,
    required this.vehicleId,
    required this.purchasePrice,
    required this.condition,
    required this.notes,
    required this.purchaseDate,
    required this.status,
    required this.nextAction,
    this.customer,
    this.vehicle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehiclePurchase.fromJson(Map<String, dynamic> json) {
    return VehiclePurchase(
      purchaseId: json['purchase_id']?.toString(),
      invoiceNumber: json['invoice_number'] ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      vehicleId: json['vehicle_id']?.toString() ?? '',
      purchasePrice:
          double.tryParse(json['purchase_price']?.toString() ?? '0') ?? 0.0,
      condition: json['condition'] ?? '',
      notes: json['notes'] ?? '',
      purchaseDate: json['purchase_date'] ?? '',
      status: json['status'] ?? 'pending',
      nextAction: json['next_action'] ?? 'servis',
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      vehicle: json['vehicle'] != null
          ? CustomerVehicle.fromJson(json['vehicle'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'invoice_number': invoiceNumber,
      'customer_id': customerId,
      'vehicle_id': vehicleId,
      'purchase_price': purchasePrice,
      'condition': condition,
      'notes': notes,
      'purchase_date': purchaseDate,
      'status': status,
      'next_action': nextAction,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  VehiclePurchase copyWith({
    String? purchaseId,
    String? invoiceNumber,
    String? customerId,
    String? vehicleId,
    double? purchasePrice,
    String? condition,
    String? notes,
    String? purchaseDate,
    String? status,
    String? nextAction,
    Customer? customer,
    CustomerVehicle? vehicle,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehiclePurchase(
      purchaseId: purchaseId ?? this.purchaseId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      vehicleId: vehicleId ?? this.vehicleId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      status: status ?? this.status,
      nextAction: nextAction ?? this.nextAction,
      customer: customer ?? this.customer,
      vehicle: vehicle ?? this.vehicle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehiclePurchase &&
          runtimeType == other.runtimeType &&
          purchaseId == other.purchaseId;

  @override
  int get hashCode => purchaseId.hashCode;
}
