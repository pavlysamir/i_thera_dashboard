import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../data_sources/patients_remote_data_source.dart';
import '../models/patients_response.dart';
import 'patients_repository.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final PatientsRemoteDataSource remoteDataSource;

  PatientsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PatientsResponse>> getPatients({
    required int pageNumber,
    required int pageSize,
    String? patientName,
  }) async {
    try {
      final response = await remoteDataSource.getPatients(
        pageNumber: pageNumber,
        pageSize: pageSize,
        patientName: patientName,
      );
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

  @override
  Future<Either<Failure, Unit>> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  }) async {
    try {
      await remoteDataSource.approveOrDisapprove(
        userId: userId,
        role: role,
        isApproved: isApproved,
        adminNote: adminNote,
      );
      return const Right(unit);
    } catch (e) {
      if (e is ServerException) {
        return Left(
          ServerFailure(e.errModel?.errorMessage ?? 'Unknown Server Error'),
        );
      } else if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Server Error'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}

