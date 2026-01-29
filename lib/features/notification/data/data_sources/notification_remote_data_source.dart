// lib/features/notifications/data/data_sources/notifications_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';
import 'package:i_thera_dashboard/features/notification/data/models/wallet_request_model.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_model.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<DoctorDetailModel> getDoctorById(int doctorId);
  Future<void> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  });
    Future<void> reviewWalletRequest({
    required int requestId,
    required bool isApproved,
    required int requestType,
    String? adminNote,
  });

    Future<WalletRequestModel> getWalletRequestDetails({
    required int doctorId,
    required int walletRequestId,
  });
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.getNotifications,
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data['isSuccess'] == true) {
          final responseData = data['responseData'] as List<dynamic>;
          return responseData
              .map(
                (json) =>
                    NotificationModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw ServerException(errModel: ErrorModel.fromJson(data));
        }
      } else {
        throw ServerException(
          errModel: ErrorModel(errorMessage: 'Invalid Response'),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }

  @override
  Future<DoctorDetailModel> getDoctorById(int doctorId) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.getDoctorById,
        query: {'doctorId': doctorId},
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data['isSuccess'] == true) {
          return DoctorDetailModel.fromJson(data['responseData']);
        } else {
          throw ServerException(errModel: ErrorModel.fromJson(data));
        }
      } else {
        throw ServerException(
          errModel: ErrorModel(errorMessage: 'Invalid Response'),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }

  @override
  Future<void> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  }) async {
    try {
      final response = await DioHelper.putData(
        url: ApiEndpoints.approveOrDisapprove,
        data: {
          'userId': userId,
          'role': role,
          'isApproved': isApproved,
          'adminNote': adminNote ?? '',
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        // Check for both 'success' and 'isSuccess' fields
        final isSuccess = data['success'] == true || data['isSuccess'] == true;

        if (!isSuccess) {
          throw ServerException(
            errModel: ErrorModel(
              errorMessage: data['message'] ?? 'Operation failed',
            ),
          );
        }
        // Success - no need to throw anything
        return;
      } else {
        throw ServerException(
          errModel: ErrorModel(errorMessage: 'Invalid Response'),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }


    @override
  Future<void> reviewWalletRequest({
    required int requestId,
    required bool isApproved,
    required int requestType,
    String? adminNote,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: ApiEndpoints.reviewWalletRequest,
        data: {
          'requestId': requestId,
          'isApproved': isApproved,
          'adminNote': adminNote ?? '',
          'requestType': requestType,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        final success = data['success'] as bool?;

        if (success != true) {
          throw ServerException(
            errModel: ErrorModel(
              errorMessage: data['message'] ?? 'Operation failed',
            ),
          );
        }

        print('Review wallet request successful: ${data['message']}');
        return;
      } else {
        throw ServerException(
          errModel: ErrorModel(errorMessage: 'Invalid Response'),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }


   @override
  Future<WalletRequestModel> getWalletRequestDetails({
    required int doctorId,
    required int walletRequestId,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.getAllDoctorsWalletRequests,
        query: {
          'DoctorId': doctorId,
          'WalletRequestId': walletRequestId,
          'PageNumber': 1,
          'PageSize': 10,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data['isSuccess'] == true) {
          final responseData = PaginatedWalletRequestResponse.fromJson(
            data['responseData'],
          );

          if (responseData.items.isEmpty) {
            throw ServerException(
              errModel: ErrorModel(errorMessage: 'Wallet request not found'),
            );
          }

          return responseData.items.first;
        } else {
          throw ServerException(errModel: ErrorModel.fromJson(data));
        }
      } else {
        throw ServerException(
          errModel: ErrorModel(errorMessage: 'Invalid Response'),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }
}



