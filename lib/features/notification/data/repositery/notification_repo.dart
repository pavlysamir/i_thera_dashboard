// lib/features/notifications/data/repositories/notifications_repository.dart
import 'package:dartz/dartz.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';
import 'package:i_thera_dashboard/features/notification/data/models/wallet_request_model.dart';
import '../../../../core/errors/failures.dart';
import '../models/notification_model.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
    Future<Either<Failure, DoctorDetailModel>> getDoctorById(int doctorId);
  Future<Either<Failure, Unit>> approveOrDisapprove({
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  });
   Future<Either<Failure, Unit>> reviewWalletRequest({
    required int requestId,
    required bool isApproved,
    required int requestType,
    String? adminNote,
  });

   Future<Either<Failure, WalletRequestModel>> getWalletRequestDetails({
    required int doctorId,
    required int walletRequestId,
  });
}
