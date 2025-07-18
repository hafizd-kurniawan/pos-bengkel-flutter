import '../../core/api/api_service.dart';
import '../../shared/models/api_response.dart';
import '../../shared/models/transaction.dart';

class TransactionRepository {
  final ApiService _apiService = ApiService();

  // Get all transactions
  Future<ApiResponse<List<Transaction>>> getTransactions({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Transaction>>(
      '/transactions',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Transaction.fromJson,
    );
  }

  // Get transaction by ID
  Future<ApiResponse<Transaction>> getTransaction(int id) async {
    return await _apiService.get<Transaction>(
      '/transactions/$id',
      fromJson: Transaction.fromJson,
    );
  }

  // Create transaction
  Future<ApiResponse<Transaction>> createTransaction({
    required DateTime transactionDate,
    required int userId,
    int? customerId,
    required int outletId,
    required String transactionType,
    String status = 'sukses',
  }) async {
    return await _apiService.post<Transaction>(
      '/transactions',
      body: {
        'transaction_date': transactionDate.toIso8601String(),
        'user_id': userId,
        'customer_id': customerId,
        'outlet_id': outletId,
        'transaction_type': transactionType,
        'status': status,
      },
      fromJson: Transaction.fromJson,
    );
  }

  // Update transaction
  Future<ApiResponse<Transaction>> updateTransaction(
    int id, {
    String? status,
  }) async {
    final body = <String, dynamic>{};
    if (status != null) body['status'] = status;

    return await _apiService.put<Transaction>(
      '/transactions/$id',
      body: body,
      fromJson: Transaction.fromJson,
    );
  }

  // Get transaction invoice
  Future<ApiResponse<Transaction>> getTransactionInvoice(int id) async {
    return await _apiService.get<Transaction>(
      '/transactions/$id/invoice',
      fromJson: Transaction.fromJson,
    );
  }

  // Get transactions by status
  Future<ApiResponse<List<Transaction>>> getTransactionsByStatus(
    String status, {
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Transaction>>(
      '/transactions/status',
      queryParameters: {
        'status': status,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Transaction.fromJson,
    );
  }

  // Get transactions by date range
  Future<ApiResponse<List<Transaction>>> getTransactionsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Transaction>>(
      '/transactions/date-range',
      queryParameters: {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Transaction.fromJson,
    );
  }

  // Get transactions by customer
  Future<ApiResponse<List<Transaction>>> getTransactionsByCustomer(
    int customerId, {
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Transaction>>(
      '/customers/$customerId/transactions',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Transaction.fromJson,
    );
  }

  // Get transactions by outlet
  Future<ApiResponse<List<Transaction>>> getTransactionsByOutlet(
    int outletId, {
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<Transaction>>(
      '/outlets/$outletId/transactions',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: Transaction.fromJson,
    );
  }

  // Delete transaction
  Future<ApiResponse<void>> deleteTransaction(int id) async {
    return await _apiService.delete<void>('/transactions/$id');
  }
}

class CashFlowRepository {
  final ApiService _apiService = ApiService();

  // Get all cash flows
  Future<ApiResponse<List<CashFlow>>> getCashFlows({
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<CashFlow>>(
      '/cash-flows',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: CashFlow.fromJson,
    );
  }

  // Create cash flow
  Future<ApiResponse<CashFlow>> createCashFlow({
    required int userId,
    required int outletId,
    required String flowType,
    required double amount,
    required String description,
    required DateTime flowDate,
  }) async {
    return await _apiService.post<CashFlow>(
      '/cash-flows',
      body: {
        'user_id': userId,
        'outlet_id': outletId,
        'flow_type': flowType,
        'amount': amount,
        'description': description,
        'flow_date': flowDate.toIso8601String(),
      },
      fromJson: CashFlow.fromJson,
    );
  }

  // Update cash flow
  Future<ApiResponse<CashFlow>> updateCashFlow(
    int id, {
    String? flowType,
    double? amount,
    String? description,
    DateTime? flowDate,
  }) async {
    final body = <String, dynamic>{};
    if (flowType != null) body['flow_type'] = flowType;
    if (amount != null) body['amount'] = amount;
    if (description != null) body['description'] = description;
    if (flowDate != null) body['flow_date'] = flowDate.toIso8601String();

    return await _apiService.put<CashFlow>(
      '/cash-flows/$id',
      body: body,
      fromJson: CashFlow.fromJson,
    );
  }

  // Get cash flows by type
  Future<ApiResponse<List<CashFlow>>> getCashFlowsByType(
    String flowType, {
    int page = 1,
    int limit = 10,
  }) async {
    return await _apiService.get<List<CashFlow>>(
      '/cash-flows/type',
      queryParameters: {
        'flow_type': flowType,
        'page': page.toString(),
        'limit': limit.toString(),
      },
      fromJson: CashFlow.fromJson,
    );
  }

  // Delete cash flow
  Future<ApiResponse<void>> deleteCashFlow(int id) async {
    return await _apiService.delete<void>('/cash-flows/$id');
  }
}

class PaymentMethodRepository {
  final ApiService _apiService = ApiService();

  // Get all payment methods
  Future<ApiResponse<List<PaymentMethod>>> getPaymentMethods() async {
    return await _apiService.get<List<PaymentMethod>>(
      '/payment-methods',
      fromJson: PaymentMethod.fromJson,
    );
  }

  // Get payment method by ID
  Future<ApiResponse<PaymentMethod>> getPaymentMethod(int id) async {
    return await _apiService.get<PaymentMethod>(
      '/payment-methods/$id',
      fromJson: PaymentMethod.fromJson,
    );
  }
}