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
  });
}

class PatientsRemoteDataSourceImpl implements PatientsRemoteDataSource {
  @override
  Future<PatientsResponse> getPatients({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.getAllPatients,
        query: {
          'PageNumber': pageNumber,
          'PageSize': pageSize,
        },
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
}

