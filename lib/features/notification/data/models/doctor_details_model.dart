// lib/features/notifications/data/models/doctor_detail_model.dart
import 'package:equatable/equatable.dart';
import 'package:i_thera_dashboard/features/notification/data/models/spicialization_field_mode.dart';

class DoctorDetailModel extends Equatable {
  final int id;
  final String userName;
  final List<SpecializationFieldModel> specializationFields;
  final String email;
  final String phoneNumber;
  final String? anotherMobileNumber;
  final int? district;
  final String? districtName;
  final int gender;
  final bool isApproved;
  final num? walletBalance;
  final String cityName;
  final String createdOn;
  final String? idImageURL;
  final String? idImageName;
  final String? resumeURL;
  final String? resumeName;
  final String? doctorImage;
  final num averageRating;
  final num currentBalance;
  final num? frozenBalance;
  final num detectedBalance;
  final int completedBookings;
  final int cancelledBookings;

  const DoctorDetailModel({
    required this.id,
    required this.userName,
    required this.specializationFields,
    required this.email,
    required this.phoneNumber,
    this.anotherMobileNumber,
    this.district,
    this.districtName,
    required this.gender,
    required this.isApproved,
    this.walletBalance,
    required this.cityName,
    required this.createdOn,
    this.idImageURL,
    this.idImageName,
    this.resumeURL,
    this.resumeName,
    this.doctorImage,
    required this.averageRating,
    required this.currentBalance,
    this.frozenBalance,
    required this.detectedBalance,
    required this.completedBookings,
    required this.cancelledBookings,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      specializationFields:
          (json['specializationFields'] as List<dynamic>?)
              ?.map(
                (e) => SpecializationFieldModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      anotherMobileNumber: json['anotherMobileNumber'],
      district: json['district'],
      districtName: json['districtName'],
      gender: json['gender'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      walletBalance: json['walletBalance'],
      cityName: json['cityName'] ?? '',
      createdOn: json['createdOn'] ?? '',
      idImageURL: json['idImageURL'],
      idImageName: json['idImageName'],
      resumeURL: json['resumeURL'],
      resumeName: json['resumeName'],
      doctorImage: json['doctorImage'],
      averageRating: json['averageRating'] ?? 0,
      currentBalance: json['currentBalance'] ?? 0,
      frozenBalance: json['frozenBalance'],
      detectedBalance: json['detectedBalance'] ?? 0,
      completedBookings: json['completedBookings'] ?? 0,
      cancelledBookings: json['cancelledBookings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'specializationFields': specializationFields
          .map((e) => e.toJson())
          .toList(),
      'email': email,
      'phoneNumber': phoneNumber,
      'anotherMobileNumber': anotherMobileNumber,
      'district': district,
      'districtName': districtName,
      'gender': gender,
      'isApproved': isApproved,
      'walletBalance': walletBalance,
      'cityName': cityName,
      'createdOn': createdOn,
      'idImageURL': idImageURL,
      'idImageName': idImageName,
      'resumeURL': resumeURL,
      'resumeName': resumeName,
      'doctorImage': doctorImage,
      'averageRating': averageRating,
      'currentBalance': currentBalance,
      'frozenBalance': frozenBalance,
      'detectedBalance': detectedBalance,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
    };
  }

  // Helper getters
  String get genderText => gender == 1 ? 'ذكر' : 'أنثى';

  String get specializationsText {
    if (specializationFields.isEmpty) return 'غير محدد';
    return specializationFields.map((e) => e.nameAr).join(', ');
  }

  String get displayImage => doctorImage ?? idImageURL ?? '';

  bool get hasImage => doctorImage != null || idImageURL != null;

  String get phoneNumber2Display => anotherMobileNumber ?? 'غير محدد';

  String get districtDisplay => districtName ?? 'غير محدد';

  String get identificationNumber => detectedBalance.toString();

  @override
  List<Object?> get props => [
    id,
    userName,
    specializationFields,
    email,
    phoneNumber,
    anotherMobileNumber,
    district,
    districtName,
    gender,
    isApproved,
    walletBalance,
    cityName,
    createdOn,
    idImageURL,
    idImageName,
    resumeURL,
    resumeName,
    doctorImage,
    averageRating,
    currentBalance,
    frozenBalance,
    detectedBalance,
    completedBookings,
    cancelledBookings,
  ];
}
