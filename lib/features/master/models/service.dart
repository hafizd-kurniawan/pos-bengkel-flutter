class Service {
  final String? serviceId;
  final String serviceName;
  final String? serviceDescription;
  final double serviceCost;
  final String? serviceCategoryId;
  final String status;
  final ServiceCategory? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    this.serviceId,
    required this.serviceName,
    this.serviceDescription,
    required this.serviceCost,
    this.serviceCategoryId,
    required this.status,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceId: json['service_id']?.toString(),
      serviceName: json['service_name'] ?? '',
      serviceDescription: json['service_description'],
      serviceCost: double.tryParse(json['service_cost']?.toString() ?? '0') ?? 0.0,
      serviceCategoryId: json['service_category_id']?.toString(),
      status: json['status'] ?? 'Aktif',
      category: json['service_category'] != null
          ? ServiceCategory.fromJson(json['service_category'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'service_description': serviceDescription,
      'service_cost': serviceCost,
      'service_category_id': serviceCategoryId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Service copyWith({
    String? serviceId,
    String? serviceName,
    String? serviceDescription,
    double? serviceCost,
    String? serviceCategoryId,
    String? status,
    ServiceCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      serviceCost: serviceCost ?? this.serviceCost,
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == 'Aktif';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service &&
          runtimeType == other.runtimeType &&
          serviceId == other.serviceId;

  @override
  int get hashCode => serviceId.hashCode;
}

class ServiceCategory {
  final String? serviceCategoryId;
  final String categoryName;
  final String? categoryDescription;
  final String? parentCategoryId;
  final String status;
  final ServiceCategory? parentCategory;
  final List<ServiceCategory>? subCategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceCategory({
    this.serviceCategoryId,
    required this.categoryName,
    this.categoryDescription,
    this.parentCategoryId,
    required this.status,
    this.parentCategory,
    this.subCategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      serviceCategoryId: json['service_category_id']?.toString(),
      categoryName: json['category_name'] ?? '',
      categoryDescription: json['category_description'],
      parentCategoryId: json['parent_category_id']?.toString(),
      status: json['status'] ?? 'Aktif',
      parentCategory: json['parent_category'] != null
          ? ServiceCategory.fromJson(json['parent_category'])
          : null,
      subCategories: json['sub_categories'] != null
          ? (json['sub_categories'] as List)
              .map((e) => ServiceCategory.fromJson(e))
              .toList()
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_category_id': serviceCategoryId,
      'category_name': categoryName,
      'category_description': categoryDescription,
      'parent_category_id': parentCategoryId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ServiceCategory copyWith({
    String? serviceCategoryId,
    String? categoryName,
    String? categoryDescription,
    String? parentCategoryId,
    String? status,
    ServiceCategory? parentCategory,
    List<ServiceCategory>? subCategories,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceCategory(
      serviceCategoryId: serviceCategoryId ?? this.serviceCategoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      status: status ?? this.status,
      parentCategory: parentCategory ?? this.parentCategory,
      subCategories: subCategories ?? this.subCategories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == 'Aktif';
  bool get hasParent => parentCategoryId != null;
  bool get hasSubCategories => subCategories != null && subCategories!.isNotEmpty;
  int get level => hasParent ? (parentCategory?.level ?? 0) + 1 : 0;

  String get fullPath {
    if (hasParent && parentCategory != null) {
      return '${parentCategory!.fullPath} > $categoryName';
    }
    return categoryName;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceCategory &&
          runtimeType == other.runtimeType &&
          serviceCategoryId == other.serviceCategoryId;

  @override
  int get hashCode => serviceCategoryId.hashCode;
}