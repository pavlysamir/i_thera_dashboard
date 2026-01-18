// lib/features/notifications/cubit/doctor_detail_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import 'package:i_thera_dashboard/features/notification/managers/doctor_details_cubit/doctor_details_state.dart';

class DoctorDetailCubit extends Cubit<DoctorDetailState> {
  final NotificationsRepository notificationsRepository;

  DoctorDetailCubit({required this.notificationsRepository})
    : super(DoctorDetailInitial());

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
}
