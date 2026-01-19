import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_model.dart';
import '../models/patients_response.dart';

abstract class PatientsRemoteDataSource {
  Future<PatientsResponse> getPatients({
    required int pageNumber,
    required int pageSize,
    String? patientName,
  });

  Future<void> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  });
}

class PatientsRemoteDataSourceImpl implements PatientsRemoteDataSource {
  @override
  Future<PatientsResponse> getPatients({
    required int pageNumber,
    required int pageSize,
    String? patientName,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'PageNumber': pageNumber,
        'PageSize': pageSize,
      };

      if (patientName != null && patientName.isNotEmpty) {
        queryParams['patientName'] = patientName;
      }

      final response = await DioHelper.getData(
        url: ApiEndpoints.getAllPatients,
        query: queryParams,
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        // Check for success flag - API uses isSuccess field
        if (data.containsKey('isSuccess') && data['isSuccess'] == false) {
          throw ServerException(errModel: ErrorModel.fromJson(data));
        }

        // API response structure: { isSuccess, responseData: { pageIndex, pageSize, count, items } }
        return PatientsResponse.fromJson(data);
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
}
