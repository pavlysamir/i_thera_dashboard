class RegionModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String internalCode;
  final int internalRef;
  final String description;
  final int cityId;
  final bool isActive;
  final bool isDeleted;
  final String createdOn;
  
  RegionModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.internalCode,
    required this.internalRef,
    required this.description,
    required this.cityId,
    required this.isActive,
    required this.isDeleted,
    required this.createdOn,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] ?? 0,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      internalCode: json['internalCode'] ?? '',
      internalRef: json['internalRef'] ?? 0,
      description: json['description'] ?? '',
      cityId: json['cityId'] ?? 0,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdOn: json['createdOn'] ?? '',
    );
  }
}
