// lib/features/notifications/data/models/notification_model.dart
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int id;
  final String value;
  final int? doctorId;
  final int? patientId;
  final int? adminId;
  final bool forAdmin;
  final String createdOn;
  final int? walletRequestId;
  final String? walletImageRequestPath;
  final int type;

  const NotificationModel({
    required this.id,
    required this.value,
    this.doctorId,
    this.patientId,
    this.adminId,
    required this.forAdmin,
    required this.createdOn,
    this.walletRequestId,
    this.walletImageRequestPath,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      value: json['value'] ?? '',
      doctorId: json['doctorId'],
      patientId: json['patientId'],
      adminId: json['adminId'],
      forAdmin: json['forAdmin'] ?? false,
      createdOn: json['createdOn'] ?? '',
      walletRequestId: json['walletRequestId'],
      walletImageRequestPath: json['walletImageRequestPath'],
      type: json['type'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'doctorId': doctorId,
      'patientId': patientId,
      'adminId': adminId,
      'forAdmin': forAdmin,
      'createdOn': createdOn,
      'walletRequestId': walletRequestId,
      'walletImageRequestPath': walletImageRequestPath,
      'type': type,
    };
  }

  // Helper getter to determine notification type
  NotificationType get notificationType {
    switch (type) {
      case 0:
        return NotificationType.joinRequest;
      case 1:
        return NotificationType.payment;
      case 3:
        return NotificationType.withdrawal;
      default:
        return NotificationType.general;
    }
  }

  // Helper getter for formatted date
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(createdOn);
      return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    } catch (e) {
      return createdOn;
    }
  }

  @override
  List<Object?> get props => [
    id,
    value,
    doctorId,
    patientId,
    adminId,
    forAdmin,
    createdOn,
    walletRequestId,
    walletImageRequestPath,
    type,
  ];
}

enum NotificationType {
  general,
  joinRequest, // type 0
  payment, // type 1
  withdrawal, // type 3
}
