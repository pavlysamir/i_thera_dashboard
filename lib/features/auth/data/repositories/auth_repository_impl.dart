import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import 'auth_repository.dart';

import '../../../../core/errors/exceptions.dart';

 class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await remoteDataSource.login(request);
      return Right(response);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.errModel?.errorMessage ?? 'Unknown Server Error'));
      } else if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Server Error'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
