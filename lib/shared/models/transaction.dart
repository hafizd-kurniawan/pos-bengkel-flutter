import 'user.dart';
import 'customer.dart';

class Transaction {
  final int transactionId;
  final String invoiceNumber;
  final DateTime transactionDate;
  final int userId;
  final int? customerId;
  final int outletId;
  final String transactionType;
  final String status;
  final User? user;
  final Customer? customer;
  final Outlet? outlet;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.transactionId,
    required this.invoiceNumber,
    required this.transactionDate,
    required this.userId,
    this.customerId,
    required this.outletId,
    required this.transactionType,
    required this.status,
    this.user,
    this.customer,
    this.outlet,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      invoiceNumber: json['invoice_number'],
      transactionDate: DateTime.parse(json['transaction_date']),
      userId: json['user_id'],
      customerId: json['customer_id'],
      outletId: json['outlet_id'],
      transactionType: json['transaction_type'],
      status: json['status'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      outlet: json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'invoice_number': invoiceNumber,
      'transaction_date': transactionDate.toIso8601String(),
      'user_id': userId,
      'customer_id': customerId,
      'outlet_id': outletId,
      'transaction_type': transactionType,
      'status': status,
      'user': user?.toJson(),
      'customer': customer?.toJson(),
      'outlet': outlet?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CashFlow {
  final int cashFlowId;
  final int userId;
  final int outletId;
  final String flowType;
  final double amount;
  final String description;
  final DateTime flowDate;
  final User? user;
  final Outlet? outlet;
  final DateTime createdAt;
  final DateTime updatedAt;

  CashFlow({
    required this.cashFlowId,
    required this.userId,
    required this.outletId,
    required this.flowType,
    required this.amount,
    required this.description,
    required this.flowDate,
    this.user,
    this.outlet,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CashFlow.fromJson(Map<String, dynamic> json) {
    return CashFlow(
      cashFlowId: json['cash_flow_id'],
      userId: json['user_id'],
      outletId: json['outlet_id'],
      flowType: json['flow_type'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      flowDate: DateTime.parse(json['flow_date']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      outlet: json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash_flow_id': cashFlowId,
      'user_id': userId,
      'outlet_id': outletId,
      'flow_type': flowType,
      'amount': amount,
      'description': description,
      'flow_date': flowDate.toIso8601String(),
      'user': user?.toJson(),
      'outlet': outlet?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PaymentMethod {
  final int paymentMethodId;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethod({
    required this.paymentMethodId,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentMethodId: json['payment_method_id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method_id': paymentMethodId,
      'name': name,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}