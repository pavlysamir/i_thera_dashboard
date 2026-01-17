import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

import '../../../../core/errors/error_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await DioHelper.postData(
        url: ApiEndpoints.login,
        data: request.toJson(),
      );

      final data = response.data;

      // Handle custom API success flag
      if (data is Map<String, dynamic>) {
         // Check explicit success flag if present
         if (data.containsKey('success') && data['success'] == false) {
            throw ServerException(errModel: ErrorModel.fromJson(data));
         }
         
         return LoginResponse.fromJson(data);
      } else {
         throw ServerException(errModel: ErrorModel(errorMessage: "Invalid response format"));
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(errModel: ErrorModel.fromJson(e.response?.data));
    }
  }
}

