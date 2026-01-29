import 'package:equatable/equatable.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/models/transaction_model.dart';
import 'package:i_thera_dashboard/features/notification/data/models/doctor_details_model.dart';

abstract class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object?> get props => [];
}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsLoaded extends DoctorDetailsState {
  final DoctorDetailModel doctor;
  final List<TransactionModel> transactions;
  final bool hasReachedMax;

  const DoctorDetailsLoaded({
    required this.doctor,
    required this.transactions,
    this.hasReachedMax = false,
  });

  DoctorDetailsLoaded copyWith({
    DoctorDetailModel? doctor,
    List<TransactionModel>? transactions,
    bool? hasReachedMax,
  }) {
    return DoctorDetailsLoaded(
      doctor: doctor ?? this.doctor,
      transactions: transactions ?? this.transactions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [doctor, transactions, hasReachedMax];
}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;

  const DoctorDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Action States (to be handled by Listeners)
class DoctorDetailsActionLoading extends DoctorDetailsState {}

class DoctorDetailsBalanceAddedSuccess extends DoctorDetailsState {
  final String message;
  const DoctorDetailsBalanceAddedSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DoctorDetailsApproveSuccess extends DoctorDetailsState {
  final bool isApproved;
  const DoctorDetailsApproveSuccess(this.isApproved);
  @override
  List<Object?> get props => [isApproved];
}

class DoctorDetailsActionError extends DoctorDetailsState {
  final String message;
  const DoctorDetailsActionError(this.message);
  @override
  List<Object?> get props => [message];
}
