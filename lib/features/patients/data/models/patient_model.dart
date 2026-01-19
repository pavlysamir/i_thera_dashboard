import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  final int id;
  final String userName;
  final String email;
  final String phoneNumber;
  final int gender;
  final int cityId;
  final int regionId;
  final String cityName;
  final String? regionName;
  final String createdOn;
  final int completedBookings;
  final int cancelledBookings;

  const PatientModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.cityId,
    required this.regionId,
    required this.cityName,
    this.regionName,
    required this.createdOn,
    required this.completedBookings,
    required this.cancelledBookings,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'] ?? 0,
      cityId: json['cityId'] ?? 0,
      regionId: json['regionId'] ?? 0,
      cityName: json['cityName'] ?? '',
      regionName: json['regionName'],
      createdOn: json['createdOn'] ?? '',
      completedBookings: json['completedBookings'],
      cancelledBookings: json['cancelledBookings'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    userName,
    email,
    phoneNumber,
    gender,
    regionId,
    regionName,
  ];
}
