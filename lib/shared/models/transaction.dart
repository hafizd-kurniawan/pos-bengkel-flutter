import 'package:pos_bengkel/core/utils/app_constants.dart';
import 'package:pos_bengkel/shared/models/customer.dart';

class Transaction {
  final String? transactionId;
  final String invoiceNumber;
  final DateTime transactionDate;
  final String userId;
  final String? customerId;
  final String? outletId;
  final String transactionType;
  final String status;
  final User? user;
  final Customer? customer;
  final Outlet? outlet;
  final List<TransactionItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    this.transactionId,
    required this.invoiceNumber,
    required this.transactionDate,
    required this.userId,
    this.customerId,
    this.outletId,
    required this.transactionType,
    required this.status,
    this.user,
    this.customer,
    this.outlet,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    List<TransactionItem> items = [];
    if (json['items'] != null) {
      items = (json['items'] as List)
          .map((item) => TransactionItem.fromJson(item))
          .toList();
    }

    return Transaction(
      transactionId: json['transaction_id']?.toString(),
      invoiceNumber: json['invoice_number'] ?? '',
      transactionDate:
          DateTime.tryParse(json['transaction_date'] ?? '') ?? DateTime.now(),
      userId: json['user_id']?.toString() ?? '',
      customerId: json['customer_id']?.toString(),
      outletId: json['outlet_id']?.toString(),
      transactionType: json['transaction_type'] ?? 'Sale',
      status: json['status'] ?? AppConstants.statusPending,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      outlet: json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null,
      items: items,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
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
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Computed properties untuk compatibility
  String get cashierId => userId;
  String? get customerName => customer?.name ?? 'Customer Umum';
  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get paidAmount => totalAmount; // Assume fully paid for now
  double get changeAmount => 0.0;
  DateTime? get dueDate => null;
  String get paymentMethod => 'cash';

  bool get isPaid => status == 'sukses' || status == AppConstants.statusPaid;
  bool get isUnpaid => status == AppConstants.statusUnpaid;
  bool get isPending => status == AppConstants.statusPending;
  bool get isCompleted => status == AppConstants.statusCompleted;
  bool get isCancelled => status == AppConstants.statusCancelled;

  double get remainingAmount => totalAmount - paidAmount;
  bool get isFullyPaid => paidAmount >= totalAmount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          transactionId == other.transactionId;

  @override
  int get hashCode => transactionId.hashCode;
}

class TransactionItem {
  final String? transactionItemId;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? serialNumber;
  final double subtotal;

  TransactionItem({
    this.transactionItemId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.serialNumber,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      transactionItemId: json['transaction_item_id']?.toString(),
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      serialNumber: json['serial_number'],
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_item_id': transactionItemId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'serial_number': serialNumber,
      'subtotal': subtotal,
    };
  }

  TransactionItem copyWith({
    String? transactionItemId,
    String? productId,
    String? productName,
    double? price,
    int? quantity,
    String? serialNumber,
    double? subtotal,
  }) {
    return TransactionItem(
      transactionItemId: transactionItemId ?? this.transactionItemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      serialNumber: serialNumber ?? this.serialNumber,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          serialNumber == other.serialNumber;

  @override
  int get hashCode => Object.hash(productId, serialNumber);
}

class User {
  final String? userId;
  final String name;
  final String email;
  final String? outletId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    this.userId,
    required this.name,
    required this.email,
    this.outletId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      outletId: json['outlet_id']?.toString(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class Outlet {
  final String? outletId;
  final String outletName;
  final String branchType;
  final String city;
  final String? address;
  final String? phoneNumber;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Outlet({
    this.outletId,
    required this.outletName,
    required this.branchType,
    required this.city,
    this.address,
    this.phoneNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      outletId: json['outlet_id']?.toString(),
      outletName: json['outlet_name'] ?? '',
      branchType: json['branch_type'] ?? '',
      city: json['city'] ?? '',
      address: json['address'],
      phoneNumber: json['phone_number'],
      status: json['status'] ?? 'Aktif',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
