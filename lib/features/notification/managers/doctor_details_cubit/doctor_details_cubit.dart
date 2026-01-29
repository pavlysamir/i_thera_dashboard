// lib/features/notifications/cubit/doctor_detail_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/notification/data/data_sources/push_notification_service.dart';
import 'package:i_thera_dashboard/features/notification/data/models/notification_model.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import 'package:i_thera_dashboard/features/notification/managers/doctor_details_cubit/doctor_details_state.dart';

class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  final NotificationsRepository notificationsRepository;
  final PushNotificationService pushNotificationService;

  DoctorDetailCubit({
    required this.notificationsRepository,
    required this.pushNotificationService,
  }) : super(DoctorDetailInitial());

  Future<void> loadDoctorDetails(int doctorId) async {
    emit(DoctorDetailLoading());

    final result = await notificationsRepository.getDoctorById(doctorId);

    result.fold(
      (failure) => emit(DoctorDetailError(failure.message)),
      (doctor) => emit(DoctorDetailLoaded(doctor: doctor)),
    );
  }

  Future<void> approveDoctor(int userId, {String? note}) async {
    emit(DoctorApprovalLoading());

    final result = await notificationsRepository.approveOrDisapprove(
      userId: userId,
      role: 1, // 1 for doctor
      isApproved: true,
      adminNote: note,
    );

    result.fold(
      (failure) => emit(DoctorDetailError(failure.message)),
      (_) => emit(const DoctorApprovalSuccess(isApproved: true)),
    );
  }

  Future<void> disapproveDoctor(int userId, {required String note}) async {
    emit(DoctorApprovalLoading());

    final result = await notificationsRepository.approveOrDisapprove(
      userId: userId,
      role: 1, // 1 for doctor
      isApproved: false,
      adminNote: note,
    );

    result.fold(
      (failure) => emit(DoctorDetailError(failure.message)),
      (_) => emit(const DoctorApprovalSuccess(isApproved: false)),
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
