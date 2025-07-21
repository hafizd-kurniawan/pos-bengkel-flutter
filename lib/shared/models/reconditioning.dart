class ReconditioningJob {
  final String? jobId;
  final String vehicleId;
  final String invoiceNumber;
  final String status; // 'open', 'in_progress', 'completed'
  final double estimatedCost;
  final double actualCost;
  final DateTime startDate;
  final DateTime? completedDate;
  final String description;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReconditioningJob({
    this.jobId,
    required this.vehicleId,
    required this.invoiceNumber,
    required this.status,
    required this.estimatedCost,
    required this.actualCost,
    required this.startDate,
    this.completedDate,
    required this.description,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReconditioningJob.fromJson(Map<String, dynamic> json) {
    return ReconditioningJob(
      jobId: json['job_id']?.toString(),
      vehicleId: json['vehicle_id']?.toString() ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      status: json['status'] ?? 'open',
      estimatedCost: double.tryParse(json['estimated_cost']?.toString() ?? '0') ?? 0.0,
      actualCost: double.tryParse(json['actual_cost']?.toString() ?? '0') ?? 0.0,
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      completedDate: json['completed_date'] != null 
          ? DateTime.tryParse(json['completed_date']) 
          : null,
      description: json['description'] ?? '',
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'vehicle_id': vehicleId,
      'invoice_number': invoiceNumber,
      'status': status,
      'estimated_cost': estimatedCost,
      'actual_cost': actualCost,
      'start_date': startDate.toIso8601String(),
      'completed_date': completedDate?.toIso8601String(),
      'description': description,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReconditioningJob copyWith({
    String? jobId,
    String? vehicleId,
    String? invoiceNumber,
    String? status,
    double? estimatedCost,
    double? actualCost,
    DateTime? startDate,
    DateTime? completedDate,
    String? description,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReconditioningJob(
      jobId: jobId ?? this.jobId,
      vehicleId: vehicleId ?? this.vehicleId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      status: status ?? this.status,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      actualCost: actualCost ?? this.actualCost,
      startDate: startDate ?? this.startDate,
      completedDate: completedDate ?? this.completedDate,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReconditioningJob &&
          runtimeType == other.runtimeType &&
          jobId == other.jobId;

  @override
  int get hashCode => jobId.hashCode;
}

class ReconditioningDetail {
  final String? detailId;
  final String jobId;
  final String itemName;
  final String itemType; // 'parts', 'service', 'materials'
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReconditioningDetail({
    this.detailId,
    required this.jobId,
    required this.itemName,
    required this.itemType,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReconditioningDetail.fromJson(Map<String, dynamic> json) {
    return ReconditioningDetail(
      detailId: json['detail_id']?.toString(),
      jobId: json['job_id']?.toString() ?? '',
      itemName: json['item_name'] ?? '',
      itemType: json['item_type'] ?? 'parts',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '0') ?? 0.0,
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail_id': detailId,
      'job_id': jobId,
      'item_name': itemName,
      'item_type': itemType,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReconditioningDetail copyWith({
    String? detailId,
    String? jobId,
    String? itemName,
    String? itemType,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReconditioningDetail(
      detailId: detailId ?? this.detailId,
      jobId: jobId ?? this.jobId,
      itemName: itemName ?? this.itemName,
      itemType: itemType ?? this.itemType,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReconditioningDetail &&
          runtimeType == other.runtimeType &&
          detailId == other.detailId;

  @override
  int get hashCode => detailId.hashCode;
}