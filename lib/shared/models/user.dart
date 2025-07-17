class User {
  final int userId;
  final String name;
  final String email;
  final int? outletId;
  final Outlet? outlet;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    this.outletId,
    this.outlet,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      outletId: json['outlet_id'],
      outlet: json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'outlet_id': outletId,
      'outlet': outlet?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Outlet {
  final int outletId;
  final String outletName;
  final String branchType;
  final String city;
  final String? address;
  final String? phoneNumber;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Outlet({
    required this.outletId,
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
      outletId: json['outlet_id'],
      outletName: json['outlet_name'],
      branchType: json['branch_type'],
      city: json['city'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'outlet_id': outletId,
      'outlet_name': outletName,
      'branch_type': branchType,
      'city': city,
      'address': address,
      'phone_number': phoneNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}