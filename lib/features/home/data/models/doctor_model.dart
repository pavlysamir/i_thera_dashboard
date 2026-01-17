import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  final int id;
  final String userName;
  final String email;
  final String phoneNumber;
  final int gender;
  final bool isApproved;
  final num walletBalance;
  final int cityId;
  final String cityName;
  final String createdOn;

  const DoctorModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.isApproved,
    required this.walletBalance,
    required this.cityId,
    required this.cityName,
    required this.createdOn,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      walletBalance: json['walletBalance'] ?? 0,
      cityId: json['cityId'] ?? 0,
      cityName: json['cityName'] ?? '',
      createdOn: json['createdOn'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, userName, email, phoneNumber, isApproved];
}
