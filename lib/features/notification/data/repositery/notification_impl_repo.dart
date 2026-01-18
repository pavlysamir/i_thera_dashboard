// lib/features/notifications/data/repositories/notifications_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/features/notification/data/data_sources/notification_remote_data_source.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';
import 'package:i_thera_dashboard/features/notification/data/models/wallet_request_model.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final response = await remoteDataSource.getNotifications();
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


  @override
  Future<Either<Failure, Unit>> reviewWalletRequest({
    required int requestId,
    required bool isApproved,
    required int requestType,
    String? adminNote,
  }) async {
    try {
      await remoteDataSource.reviewWalletRequest(
        requestId: requestId,
        isApproved: isApproved,
        requestType: requestType,
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

   @override
  Future<Either<Failure, WalletRequestModel>> getWalletRequestDetails({
    required int doctorId,
    required int walletRequestId,
  }) async {
    try {
      final response = await remoteDataSource.getWalletRequestDetails(
        doctorId: doctorId,
        walletRequestId: walletRequestId,
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
}
