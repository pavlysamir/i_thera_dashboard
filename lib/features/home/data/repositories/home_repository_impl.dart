import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../data_sources/home_remote_data_source.dart';
import '../models/doctor_model.dart';
import '../models/paginated_response.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedResponse<DoctorModel>>> getDoctors({required int pageNumber, int pageSize = 13}) async {
    try {
      final response = await remoteDataSource.getDoctors(pageNumber: pageNumber, pageSize: pageSize);
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
