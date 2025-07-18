import 'package:pos_bengkel/core/services/api_service.dart';
import 'package:pos_bengkel/shared/models/transaction.dart';

class TransactionRepository {
  final ApiService _apiService;

  TransactionRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // POST /api/v1/transactions - Sesuai spec API
  Future<ApiResponse<Transaction>> createTransaction(
      Map<String, dynamic> transactionData) async {
    try {
      return await _apiService.post<Transaction>(
        '/transactions',
        data: transactionData,
        fromJson: (data) => Transaction.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal membuat transaksi: $e');
    }
  }

  // GET /api/v1/transactions - Sesuai endpoint di README.md
  Future<ApiResponse<List<Transaction>>> getTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
        if (startDate != null && startDate.isNotEmpty) 'start_date': startDate,
        if (endDate != null && endDate.isNotEmpty) 'end_date': endDate,
      };

      return await _apiService.get<List<Transaction>>(
        '/transactions',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) =>
                    Transaction.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Transaction>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil data transaksi: $e');
    }
  }

  // GET /api/v1/transactions/:id - Sesuai endpoint di README.md
  Future<ApiResponse<Transaction>> getTransactionById(String id) async {
    try {
      return await _apiService.get<Transaction>(
        '/transactions/$id',
        fromJson: (data) => Transaction.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil detail transaksi: $e');
    }
  }

  // GET /api/v1/transactions/invoice/:id - Sesuai endpoint di README.md
  Future<ApiResponse<String>> getInvoice(String transactionId) async {
    try {
      return await _apiService.get<String>(
        '/transactions/$transactionId/invoice',
        fromJson: (data) => data.toString(),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil invoice: $e');
    }
  }

  // GET /api/v1/transactions/status - Sesuai endpoint di README.md
  Future<ApiResponse<List<Transaction>>> getTransactionsByStatus(
      String status) async {
    try {
      final queryParams = {
        'status': status,
      };

      return await _apiService.get<List<Transaction>>(
        '/transactions/status',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) =>
                    Transaction.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Transaction>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Gagal mengambil transaksi berdasarkan status: $e');
    }
  }

  // GET /api/v1/transactions/date-range - Sesuai endpoint di README.md
  Future<ApiResponse<List<Transaction>>> getTransactionsByDateRange(
    String startDate,
    String endDate,
  ) async {
    try {
      final queryParams = {
        'start_date': startDate,
        'end_date': endDate,
      };

      return await _apiService.get<List<Transaction>>(
        '/transactions/date-range',
        queryParameters: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data
                .map((json) =>
                    Transaction.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          return <Transaction>[];
        },
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          'Gagal mengambil transaksi berdasarkan rentang tanggal: $e');
    }
  }
}
