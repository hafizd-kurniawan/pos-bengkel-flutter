class Customer {
  final String? customerId;
  final String name;
  final String phoneNumber;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    this.customerId,
    required this.name,
    required this.phoneNumber,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id']?.toString(),
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Customer copyWith({
    String? customerId,
    String? name,
    String? phoneNumber,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          customerId == other.customerId;

  @override
  int get hashCode => customerId.hashCode;
}
