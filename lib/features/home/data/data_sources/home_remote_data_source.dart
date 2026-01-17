import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/error_model.dart';
import '../models/doctor_model.dart';
import '../models/paginated_response.dart';

abstract class HomeRemoteDataSource {
  Future<PaginatedResponse<DoctorModel>> getDoctors({
    required int pageNumber,
    int pageSize = 10,
  });
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<PaginatedResponse<DoctorModel>> getDoctors({
    required int pageNumber,
    int pageSize = 13,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: ApiEndpoints.getAllDoctors,
        query: {'PageNumber': pageNumber, 'PageSize': pageSize},
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        if (data['isSuccess'] == true) {
          return PaginatedResponse<DoctorModel>.fromJson(
            data['responseData'],
            (json) => DoctorModel.fromJson(json),
          );
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
