import 'package:equatable/equatable.dart';

abstract class PatientDetailState extends Equatable {
  const PatientDetailState();

  @override
  List<Object?> get props => [];
}

class PatientDetailInitial extends PatientDetailState {}

class PatientDetailLoading extends PatientDetailState {}

class PatientApprovalLoading extends PatientDetailState {}

class PatientApprovalSuccess extends PatientDetailState {
  final bool isApproved;
  const PatientApprovalSuccess({required this.isApproved});

  @override
  List<Object> get props => [isApproved];
}

class PatientDetailError extends PatientDetailState {
  final String message;

  const PatientDetailError(this.message);

  @override
  List<Object> get props => [message];
}
