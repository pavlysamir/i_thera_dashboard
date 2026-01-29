// lib/features/notifications/cubit/notifications_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import 'package:i_thera_dashboard/features/notification/data/data_sources/push_notification_service.dart';
import 'package:i_thera_dashboard/features/notification/data/models/notification_model.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository notificationsRepository;
  final PushNotificationService pushNotificationService;

  NotificationsCubit({
    required this.notificationsRepository,
    required this.pushNotificationService,
  }) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());

    final result = await notificationsRepository.getNotifications();

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) =>
          emit(NotificationsLoaded(notifications: notifications)),
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
