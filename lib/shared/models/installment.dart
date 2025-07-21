class Installment {
  final String? installmentId;
  final String transactionId;
  final String vehicleId;
  final String customerId;
  final String customerName;
  final double totalAmount;
  final double downPayment;
  final double remainingAmount;
  final int installmentMonths;
  final double monthlyPayment;
  final double interestRate;
  final DateTime startDate;
  final String status; // 'active', 'completed', 'defaulted'
  final DateTime createdAt;
  final DateTime updatedAt;

  Installment({
    this.installmentId,
    required this.transactionId,
    required this.vehicleId,
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    required this.downPayment,
    required this.remainingAmount,
    required this.installmentMonths,
    required this.monthlyPayment,
    required this.interestRate,
    required this.startDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      installmentId: json['installment_id']?.toString(),
      transactionId: json['transaction_id']?.toString() ?? '',
      vehicleId: json['vehicle_id']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      customerName: json['customer_name'] ?? '',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      downPayment: double.tryParse(json['down_payment']?.toString() ?? '0') ?? 0.0,
      remainingAmount: double.tryParse(json['remaining_amount']?.toString() ?? '0') ?? 0.0,
      installmentMonths: int.tryParse(json['installment_months']?.toString() ?? '0') ?? 0,
      monthlyPayment: double.tryParse(json['monthly_payment']?.toString() ?? '0') ?? 0.0,
      interestRate: double.tryParse(json['interest_rate']?.toString() ?? '0') ?? 0.0,
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'active',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installment_id': installmentId,
      'transaction_id': transactionId,
      'vehicle_id': vehicleId,
      'customer_id': customerId,
      'customer_name': customerName,
      'total_amount': totalAmount,
      'down_payment': downPayment,
      'remaining_amount': remainingAmount,
      'installment_months': installmentMonths,
      'monthly_payment': monthlyPayment,
      'interest_rate': interestRate,
      'start_date': startDate.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Installment copyWith({
    String? installmentId,
    String? transactionId,
    String? vehicleId,
    String? customerId,
    String? customerName,
    double? totalAmount,
    double? downPayment,
    double? remainingAmount,
    int? installmentMonths,
    double? monthlyPayment,
    double? interestRate,
    DateTime? startDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Installment(
      installmentId: installmentId ?? this.installmentId,
      transactionId: transactionId ?? this.transactionId,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      downPayment: downPayment ?? this.downPayment,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      installmentMonths: installmentMonths ?? this.installmentMonths,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      interestRate: interestRate ?? this.interestRate,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Installment &&
          runtimeType == other.runtimeType &&
          installmentId == other.installmentId;

  @override
  int get hashCode => installmentId.hashCode;
}

class InstallmentPayment {
  final String? paymentId;
  final String installmentId;
  final int installmentNumber;
  final double amount;
  final double lateFee;
  final DateTime dueDate;
  final DateTime? paidDate;
  final String status; // 'pending', 'paid', 'overdue'
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  InstallmentPayment({
    this.paymentId,
    required this.installmentId,
    required this.installmentNumber,
    required this.amount,
    required this.lateFee,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstallmentPayment.fromJson(Map<String, dynamic> json) {
    return InstallmentPayment(
      paymentId: json['payment_id']?.toString(),
      installmentId: json['installment_id']?.toString() ?? '',
      installmentNumber: int.tryParse(json['installment_number']?.toString() ?? '0') ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      lateFee: double.tryParse(json['late_fee']?.toString() ?? '0') ?? 0.0,
      dueDate: DateTime.tryParse(json['due_date'] ?? '') ?? DateTime.now(),
      paidDate: json['paid_date'] != null ? DateTime.tryParse(json['paid_date']) : null,
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'],
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'installment_id': installmentId,
      'installment_number': installmentNumber,
      'amount': amount,
      'late_fee': lateFee,
      'due_date': dueDate.toIso8601String(),
      'paid_date': paidDate?.toIso8601String(),
      'status': status,
      'payment_method': paymentMethod,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  InstallmentPayment copyWith({
    String? paymentId,
    String? installmentId,
    int? installmentNumber,
    double? amount,
    double? lateFee,
    DateTime? dueDate,
    DateTime? paidDate,
    String? status,
    String? paymentMethod,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InstallmentPayment(
      paymentId: paymentId ?? this.paymentId,
      installmentId: installmentId ?? this.installmentId,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      amount: amount ?? this.amount,
      lateFee: lateFee ?? this.lateFee,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isOverdue => status == 'pending' && DateTime.now().isAfter(dueDate);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstallmentPayment &&
          runtimeType == other.runtimeType &&
          paymentId == other.paymentId;

  @override
  int get hashCode => paymentId.hashCode;
}

class InstallmentSchedule {
  final int installmentNumber;
  final DateTime dueDate;
  final double amount;
  final double remainingBalance;

  InstallmentSchedule({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    required this.remainingBalance,
  });

  factory InstallmentSchedule.fromJson(Map<String, dynamic> json) {
    return InstallmentSchedule(
      installmentNumber: int.tryParse(json['installment_number']?.toString() ?? '0') ?? 0,
      dueDate: DateTime.tryParse(json['due_date'] ?? '') ?? DateTime.now(),
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      remainingBalance: double.tryParse(json['remaining_balance']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installment_number': installmentNumber,
      'due_date': dueDate.toIso8601String(),
      'amount': amount,
      'remaining_balance': remainingBalance,
    };
  }
}