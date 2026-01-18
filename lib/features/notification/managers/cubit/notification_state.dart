// lib/features/notifications/cubit/notifications_state.dart
import 'package:equatable/equatable.dart';
import 'package:i_thera_dashboard/features/notification/data/models/notification_model.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  const NotificationsLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationMarkedAsRead extends NotificationsState {
  final int notificationId;

  const NotificationMarkedAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
