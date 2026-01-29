// lib/features/notifications/cubit/wallet_request_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/notification/data/data_sources/push_notification_service.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import 'wallet_request_state.dart';

class WalletRequestCubit extends Cubit<WalletRequestState> {
  final NotificationsRepository notificationsRepository;
  final PushNotificationService pushNotificationService;

  WalletRequestCubit({
    required this.notificationsRepository,
    required this.pushNotificationService,
  }) : super(WalletRequestInitial());

  Future<void> loadWalletRequestDetails({
    required int doctorId,
    required int walletRequestId,
  }) async {
    emit(WalletRequestLoading());

    final result = await notificationsRepository.getWalletRequestDetails(
      doctorId: doctorId,
      walletRequestId: walletRequestId,
    );

    result.fold(
      (failure) => emit(WalletRequestError(failure.message)),
      (walletRequest) =>
          emit(WalletRequestLoaded(walletRequest: walletRequest)),
    );
  }

  Future<void> reviewWalletRequest({
    required int requestId,
    required bool isApproved,
    required int requestType,
    String? adminNote,
  }) async {
    emit(WalletRequestReviewLoading());

    final result = await notificationsRepository.reviewWalletRequest(
      requestId: requestId,
      isApproved: isApproved,
      requestType: requestType,
      adminNote: adminNote,
    );

    result.fold(
      (failure) => emit(WalletRequestError(failure.message)),
      (_) => emit(WalletRequestReviewSuccess(isApproved: isApproved)),
    );
  }

  Future<void> sendValidationNotification(
    int? notificationType,
    int? doctorId,
    int? notificationId,
  ) async {
    // We don't necessarily need to emit state changes here unless we want to show loading/success for the push
    // For now, we just fire and forget, or log.
    await pushNotificationService.sendNotificationToDoctor(
      notificationType,
      doctorId,
      notificationId,
    );
  }
}
