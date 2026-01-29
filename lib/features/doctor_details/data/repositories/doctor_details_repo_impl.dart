import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/core/errors/exceptions.dart';
import 'package:i_thera_dashboard/core/errors/failures.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/data_sources/doctor_details_remote_data_source.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/models/paginated_transaction_response.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart'; // Reuse

abstract class DoctorDetailsRepository {
  Future<Either<Failure, DoctorDetailModel>> getDoctorById(int doctorId);
  Future<Either<Failure, PaginatedTransactionResponse>> getDoctorTransactions({
    required int doctorId,
    required int pageNumber,
    required int pageSize,
  });
  Future<Either<Failure, Unit>> addBalanceToDoctor({
    required int doctorId,
    required num amount,
    required String description,
  });
  Future<Either<Failure, Unit>> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  });
}

class DoctorDetailsRepositoryImpl implements DoctorDetailsRepository {
  final DoctorDetailsRemoteDataSource remoteDataSource;

  DoctorDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DoctorDetailModel>> getDoctorById(int doctorId) async {
    try {
      final response = await remoteDataSource.getDoctorById(doctorId);
      return Right(response);
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

  @override
  Future<Either<Failure, PaginatedTransactionResponse>> getDoctorTransactions({
    required int doctorId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await remoteDataSource.getDoctorTransactions(
        doctorId: doctorId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return Right(response);
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

  @override
  Future<Either<Failure, Unit>> addBalanceToDoctor({
    required int doctorId,
    required num amount,
    required String description,
  }) async {
    try {
      await remoteDataSource.addBalanceToDoctor(
        doctorId: doctorId,
        amount: amount,
        description: description,
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
