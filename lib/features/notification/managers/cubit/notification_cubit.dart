// lib/features/notifications/cubit/notifications_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository notificationsRepository;

  NotificationsCubit({required this.notificationsRepository})
    : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());

    final result = await notificationsRepository.getNotifications();

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) =>
          emit(NotificationsLoaded(notifications: notifications)),
    );
  }
}
