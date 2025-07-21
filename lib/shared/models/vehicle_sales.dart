class VehicleSalesTransaction {
  final String? transactionId;
  final String vehicleId;
  final String invoiceNumber;
  final String customerId;
  final String customerName;
  final double salePrice;
  final double purchasePrice; // Original purchase price for profit calculation
  final String paymentMethod; // 'cash', 'credit', 'installment'
  final String status; // 'pending', 'completed', 'cancelled'
  final DateTime transactionDate;
  final double? downPayment;
  final int? installmentMonths;
  final double? monthlyPayment;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleSalesTransaction({
    this.transactionId,
    required this.vehicleId,
    required this.invoiceNumber,
    required this.customerId,
    required this.customerName,
    required this.salePrice,
    required this.purchasePrice,
    required this.paymentMethod,
    required this.status,
    required this.transactionDate,
    this.downPayment,
    this.installmentMonths,
    this.monthlyPayment,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleSalesTransaction.fromJson(Map<String, dynamic> json) {
    return VehicleSalesTransaction(
      transactionId: json['transaction_id']?.toString(),
      vehicleId: json['vehicle_id']?.toString() ?? '',
      invoiceNumber: json['invoice_number'] ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      customerName: json['customer_name'] ?? '',
      salePrice: double.tryParse(json['sale_price']?.toString() ?? '0') ?? 0.0,
      purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method'] ?? 'cash',
      status: json['status'] ?? 'pending',
      transactionDate: DateTime.tryParse(json['transaction_date'] ?? '') ?? DateTime.now(),
      downPayment: double.tryParse(json['down_payment']?.toString() ?? ''),
      installmentMonths: int.tryParse(json['installment_months']?.toString() ?? ''),
      monthlyPayment: double.tryParse(json['monthly_payment']?.toString() ?? ''),
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'vehicle_id': vehicleId,
      'invoice_number': invoiceNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'sale_price': salePrice,
      'purchase_price': purchasePrice,
      'payment_method': paymentMethod,
      'status': status,
      'transaction_date': transactionDate.toIso8601String(),
      'down_payment': downPayment,
      'installment_months': installmentMonths,
      'monthly_payment': monthlyPayment,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  VehicleSalesTransaction copyWith({
    String? transactionId,
    String? vehicleId,
    String? invoiceNumber,
    String? customerId,
    String? customerName,
    double? salePrice,
    double? purchasePrice,
    String? paymentMethod,
    String? status,
    DateTime? transactionDate,
    double? downPayment,
    int? installmentMonths,
    double? monthlyPayment,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehicleSalesTransaction(
      transactionId: transactionId ?? this.transactionId,
      vehicleId: vehicleId ?? this.vehicleId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      salePrice: salePrice ?? this.salePrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      transactionDate: transactionDate ?? this.transactionDate,
      downPayment: downPayment ?? this.downPayment,
      installmentMonths: installmentMonths ?? this.installmentMonths,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get profit => salePrice - purchasePrice;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleSalesTransaction &&
          runtimeType == other.runtimeType &&
          transactionId == other.transactionId;

  @override
  int get hashCode => transactionId.hashCode;
}

class VehicleProfit {
  final String vehicleId;
  final double purchasePrice;
  final double salePrice;
  final double reconditioningCost;
  final double grossProfit;
  final double netProfit;
  final double profitMargin;

  VehicleProfit({
    required this.vehicleId,
    required this.purchasePrice,
    required this.salePrice,
    required this.reconditioningCost,
    required this.grossProfit,
    required this.netProfit,
    required this.profitMargin,
  });

  factory VehicleProfit.fromJson(Map<String, dynamic> json) {
    return VehicleProfit(
      vehicleId: json['vehicle_id']?.toString() ?? '',
      purchasePrice: double.tryParse(json['purchase_price']?.toString() ?? '0') ?? 0.0,
      salePrice: double.tryParse(json['sale_price']?.toString() ?? '0') ?? 0.0,
      reconditioningCost: double.tryParse(json['reconditioning_cost']?.toString() ?? '0') ?? 0.0,
      grossProfit: double.tryParse(json['gross_profit']?.toString() ?? '0') ?? 0.0,
      netProfit: double.tryParse(json['net_profit']?.toString() ?? '0') ?? 0.0,
      profitMargin: double.tryParse(json['profit_margin']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'purchase_price': purchasePrice,
      'sale_price': salePrice,
      'reconditioning_cost': reconditioningCost,
      'gross_profit': grossProfit,
      'net_profit': netProfit,
      'profit_margin': profitMargin,
    };
  }
}