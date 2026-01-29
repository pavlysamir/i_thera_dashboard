import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/core/errors/error_model.dart';
import 'package:i_thera_dashboard/core/errors/exceptions.dart';
import 'package:i_thera_dashboard/core/network/api_endpoints.dart';
import 'package:i_thera_dashboard/core/network/dio_helper.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/models/paginated_transaction_response.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart'; // Reusing existing model

abstract class DoctorDetailsRemoteDataSource {
  Future<DoctorDetailModel> getDoctorById(int doctorId);
  Future<PaginatedTransactionResponse> getDoctorTransactions({
    required int doctorId,
    required int pageNumber,
    required int pageSize,
  });
  Future<void> addBalanceToDoctor({
    required int doctorId,
    required num amount,
    required String description,
  });
  Future<void> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  });
}

class DoctorDetailsRemoteDataSourceImpl implements DoctorDetailsRemoteDataSource {
  @override
  Future<DoctorDetailModel> getDoctorById(int doctorId) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.getDoctorById,
        query: {'doctorId': doctorId},
      );

      final data = response.data;

      if (data is Map<String, dynamic> && data['isSuccess'] == true) {
        return DoctorDetailModel.fromJson(data['responseData']);
      } else {
        throw ServerException(
          errModel: ErrorModel.fromJson(data),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }

  @override
  Future<PaginatedTransactionResponse> getDoctorTransactions({
    required int doctorId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      // Dynamic URL construction for: /api/Admin/{id}/transactions
      final url = '/api/Admin/$doctorId/transactions';
      
      final response = await DioHelper.getData(
        url: url,
        query: {
          'PageNumber': pageNumber,
          'PageSize': pageSize,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic> && data['isSuccess'] == true) {
        return PaginatedTransactionResponse.fromJson(data['responseData']);
      } else {
        throw ServerException(
          errModel: ErrorModel.fromJson(data),
        );
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }

  @override
  Future<void> addBalanceToDoctor({
    required int doctorId,
    required num amount,
    required String description,
  }) async {
    try {
      // Endpoint expects query parameters: ?doctorId=...&amount=...&description=...
      final response = await DioHelper.postData(
        url: ApiEndpoints.addBalanceToDoctor,
        query: {
          'doctorId': doctorId,
          'amount': amount,
          'description': description,
        },
        data: {}, // Valid empty body as per curl -d ''
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
         final isSuccess = data['success'] == true || data['isSuccess'] == true;
         if (!isSuccess) {
            throw ServerException(
              errModel: ErrorModel(errorMessage: data['message'] ?? 'Operation failed'),
            );
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
        final isSuccess = data['success'] == true || data['isSuccess'] == true;
        if (!isSuccess) {
          throw ServerException(
            errModel: ErrorModel(errorMessage: data['message'] ?? 'Operation failed'),
          );
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
