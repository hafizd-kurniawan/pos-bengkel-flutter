import 'package:pos_bengkel/features/master/models/service.dart';

class PriceList {
  final String? priceListId;
  final String serviceId;
  final double price;
  final DateTime effectiveDate;
  final DateTime? endDate;
  final String status;
  final String? notes;
  final Service? service;
  final DateTime createdAt;
  final DateTime updatedAt;

  PriceList({
    this.priceListId,
    required this.serviceId,
    required this.price,
    required this.effectiveDate,
    this.endDate,
    required this.status,
    this.notes,
    this.service,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PriceList.fromJson(Map<String, dynamic> json) {
    return PriceList(
      priceListId: json['price_list_id']?.toString(),
      serviceId: json['service_id']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      effectiveDate: DateTime.tryParse(json['effective_date'] ?? '') ?? DateTime.now(),
      endDate: json['end_date'] != null 
          ? DateTime.tryParse(json['end_date'])
          : null,
      status: json['status'] ?? 'Aktif',
      notes: json['notes'],
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price_list_id': priceListId,
      'service_id': serviceId,
      'price': price,
      'effective_date': effectiveDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PriceList copyWith({
    String? priceListId,
    String? serviceId,
    double? price,
    DateTime? effectiveDate,
    DateTime? endDate,
    String? status,
    String? notes,
    Service? service,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PriceList(
      priceListId: priceListId ?? this.priceListId,
      serviceId: serviceId ?? this.serviceId,
      price: price ?? this.price,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      service: service ?? this.service,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == 'Aktif';
  bool get isCurrentlyEffective {
    final now = DateTime.now();
    return isActive && 
           effectiveDate.isBefore(now) && 
           (endDate == null || endDate!.isAfter(now));
  }
  
  bool get isExpired => endDate != null && endDate!.isBefore(DateTime.now());
  bool get isFutureEffective => effectiveDate.isAfter(DateTime.now());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceList &&
          runtimeType == other.runtimeType &&
          priceListId == other.priceListId;

  @override
  int get hashCode => priceListId.hashCode;
}

class PriceHistory {
  final String serviceId;
  final String serviceName;
  final List<PriceList> priceHistory;

  PriceHistory({
    required this.serviceId,
    required this.serviceName,
    required this.priceHistory,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      serviceId: json['service_id']?.toString() ?? '',
      serviceName: json['service_name'] ?? '',
      priceHistory: json['price_history'] != null
          ? (json['price_history'] as List)
              .map((e) => PriceList.fromJson(e))
              .toList()
          : [],
    );
  }

  PriceList? get currentPrice {
    return priceHistory
        .where((price) => price.isCurrentlyEffective)
        .fold<PriceList?>(null, (current, price) {
          if (current == null) return price;
          return price.effectiveDate.isAfter(current.effectiveDate) 
              ? price 
              : current;
        });
  }

  PriceList? get latestPrice {
    if (priceHistory.isEmpty) return null;
    return priceHistory.reduce((a, b) => 
        a.effectiveDate.isAfter(b.effectiveDate) ? a : b);
  }

  List<PriceList> get futurePrice {
    return priceHistory
        .where((price) => price.isFutureEffective)
        .toList()
      ..sort((a, b) => a.effectiveDate.compareTo(b.effectiveDate));
  }

  double? get priceChange {
    if (priceHistory.length < 2) return null;
    
    final sortedHistory = List<PriceList>.from(priceHistory)
      ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));
    
    if (sortedHistory.length >= 2) {
      final latest = sortedHistory[0];
      final previous = sortedHistory[1];
      return latest.price - previous.price;
    }
    
    return null;
  }

  double? get priceChangePercentage {
    final change = priceChange;
    if (change == null || priceHistory.length < 2) return null;
    
    final sortedHistory = List<PriceList>.from(priceHistory)
      ..sort((a, b) => b.effectiveDate.compareTo(a.effectiveDate));
    
    final previous = sortedHistory[1];
    if (previous.price == 0) return null;
    
    return (change / previous.price) * 100;
  }
}