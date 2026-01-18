// lib/features/notifications/data/models/wallet_request_model.dart
import 'package:equatable/equatable.dart';

class WalletRequestModel extends Equatable {
  final int id;
  final int doctorId;
  final num amount;
  final int requestType;
  final int status;
  final String mobileNumber;
  final int walletProvider;
  final String transferFromNumber;
  final String? withdrawalReason;
  final String? imageURL;
  final String createdOn;

  const WalletRequestModel({
    required this.id,
    required this.doctorId,
    required this.amount,
    required this.requestType,
    required this.status,
    required this.mobileNumber,
    required this.walletProvider,
    required this.transferFromNumber,
    this.withdrawalReason,
    this.imageURL,
    required this.createdOn,
  });

  factory WalletRequestModel.fromJson(Map<String, dynamic> json) {
    return WalletRequestModel(
      id: json['id'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      amount: json['amount'] ?? 0,
      requestType: json['requestType'] ?? 0,
      status: json['status'] ?? 0,
      mobileNumber: json['mobileNumber'] ?? '',
      walletProvider: json['walletProvider'] ?? 1,
      transferFromNumber: json['transferFromNumber'] ?? '',
      withdrawalReason: json['withdrawalReason'],
      imageURL: json['imageURL'],
      createdOn: json['createdOn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'amount': amount,
      'requestType': requestType,
      'status': status,
      'mobileNumber': mobileNumber,
      'walletProvider': walletProvider,
      'transferFromNumber': transferFromNumber,
      'withdrawalReason': withdrawalReason,
      'imageURL': imageURL,
      'createdOn': createdOn,
    };
  }

  String get requestTypeText {
    switch (requestType) {
      case 0:
        return 'طلب إضافة رصيد';
      case 1:
        return 'طلب سحب رصيد';
      default:
        return 'طلب محفظة';
    }
  }

  String get walletProviderText {
    switch (walletProvider) {
      case 1:
        return 'اورنج كاش';
      case 2:
        return 'انستاباي';
      default:
        return 'فودافون كاش';
    }
  }

  String get formattedDate {
    try {
      final dateTime = DateTime.parse(createdOn);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdOn;
    }
  }

  @override
  List<Object?> get props => [
    id,
    doctorId,
    amount,
    requestType,
    status,
    mobileNumber,
    walletProvider,
    transferFromNumber,
    withdrawalReason,
    imageURL,
    createdOn,
  ];
}

// Paginated response model
class PaginatedWalletRequestResponse {
  final int pageIndex;
  final int pageSize;
  final int count;
  final List<WalletRequestModel> items;

  PaginatedWalletRequestResponse({
    required this.pageIndex,
    required this.pageSize,
    required this.count,
    required this.items,
  });

  factory PaginatedWalletRequestResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedWalletRequestResponse(
      pageIndex: json['pageIndex'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      count: json['count'] ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    WalletRequestModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}
