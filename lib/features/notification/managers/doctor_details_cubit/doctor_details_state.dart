// lib/features/notifications/cubit/doctor_detail_state.dart
import 'package:equatable/equatable.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';

abstract class DoctorDetailState extends Equatable {
  const DoctorDetailState();

  @override
  List<Object?> get props => [];
}

class DoctorDetailInitial extends DoctorDetailState {}

class DoctorDetailLoading extends DoctorDetailState {}

class DoctorDetailLoaded extends DoctorDetailState {
  final DoctorDetailModel doctor;

  const DoctorDetailLoaded({required this.doctor});

  @override
  List<Object?> get props => [doctor];
}

class DoctorDetailError extends DoctorDetailState {
  final String message;

  const DoctorDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class DoctorApprovalSuccess extends DoctorDetailState {
  final bool isApproved;

  const DoctorApprovalSuccess({required this.isApproved});

  @override
  List<Object?> get props => [isApproved];
}

class DoctorApprovalLoading extends DoctorDetailState {}
