import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pos_bengkel/core/utils/app_constants.dart';
import 'package:pos_bengkel/shared/models/customer.dart';
import 'package:pos_bengkel/shared/models/product.dart';
import 'package:pos_bengkel/shared/models/transaction.dart';

class CartProvider extends ChangeNotifier {
  List<TransactionItem> _items = [];
  Customer? _selectedCustomer;
  String _paymentMethod = AppConstants.paymentCash;
  double _paidAmount = 0.0;
  String _invoiceNumber = '';

  // Getters
  List<TransactionItem> get items => _items;
  Customer? get selectedCustomer => _selectedCustomer;
  String get paymentMethod => _paymentMethod;
  double get paidAmount => _paidAmount;
  String get invoiceNumber => _invoiceNumber;

  // Computed properties
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get total => subtotal;
  double get changeAmount => _paidAmount > total ? _paidAmount - total : 0.0;
  bool get canCheckout =>
      _items.isNotEmpty &&
      (_paymentMethod != AppConstants.paymentCash || _paidAmount >= total);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.length;

  CartProvider() {
    _generateInvoiceNumber();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd-HHmmss');
    _invoiceNumber = 'INV-${formatter.format(now)}';
  }

  void addItem(Product product, {int quantity = 1, String? serialNumber}) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.productId == product.productId &&
          item.serialNumber == serialNumber,
    );

    if (existingIndex >= 0) {
      // Update existing item
      final existingItem = _items[existingIndex];
      final newQuantity = existingItem.quantity + quantity;
      _items[existingIndex] = existingItem.copyWith(
        quantity: newQuantity,
        subtotal: product.sellingPrice * newQuantity,
      );
    } else {
      // Add new item
      _items.add(TransactionItem(
        productId: product.productId!,
        productName: product.name,
        price: product.sellingPrice,
        quantity: quantity,
        serialNumber: serialNumber,
        subtotal: product.sellingPrice * quantity,
      ));
    }

    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateItemQuantity(int index, int quantity) {
    if (index >= 0 && index < _items.length && quantity > 0) {
      final item = _items[index];
      _items[index] = item.copyWith(
        quantity: quantity,
        subtotal: item.price * quantity,
      );
      notifyListeners();
    }
  }

  void updateItemSerialNumber(int index, String? serialNumber) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      _items[index] = item.copyWith(serialNumber: serialNumber);
      notifyListeners();
    }
  }

  void setCustomer(Customer? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setPaidAmount(double amount) {
    _paidAmount = amount;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _selectedCustomer = null;
    _paymentMethod = AppConstants.paymentCash;
    _paidAmount = 0.0;
    _generateInvoiceNumber();
    notifyListeners();
  }

  // Format untuk POST transaction sesuai API spec
  Map<String, dynamic> toTransactionJson(String userId, String outletId) {
    return {
      "invoice_number": _invoiceNumber,
      "transaction_date": DateTime.now().toUtc().toIso8601String(),
      "user_id": int.parse(userId),
      "customer_id": _selectedCustomer?.customerId != null
          ? int.parse(_selectedCustomer!.customerId!)
          : null,
      "outlet_id": int.parse(outletId),
      "transaction_type": "Sale",
      "status":
          _paymentMethod == AppConstants.paymentCash && _paidAmount >= total
              ? "sukses"
              : "pending",
    };
  }

  Transaction toTransaction(String userId) {
    return Transaction(
      invoiceNumber: _invoiceNumber,
      transactionDate: DateTime.now(),
      userId: userId,
      customerId: _selectedCustomer?.customerId,
      transactionType: 'Sale',
      status: _paymentMethod == AppConstants.paymentCash && _paidAmount >= total
          ? 'sukses'
          : AppConstants.statusUnpaid,
      customer: _selectedCustomer,
      items: _items,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
