// lib/features/notifications/data/models/specialization_field_model.dart
import 'package:equatable/equatable.dart';

class SpecializationFieldModel extends Equatable {
  final int id;
  final String nameEn;
  final String nameAr;

  const SpecializationFieldModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });

  factory SpecializationFieldModel.fromJson(Map<String, dynamic> json) {
    return SpecializationFieldModel(
      id: json['id'] ?? 0,
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nameEn': nameEn, 'nameAr': nameAr};
  }

  @override
  List<Object?> get props => [id, nameEn, nameAr];
}
