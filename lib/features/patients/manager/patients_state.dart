import 'package:equatable/equatable.dart';
import '../data/models/patients_response.dart';

abstract class PatientsState extends Equatable {
  const PatientsState();

  @override
  List<Object> get props => [];
}

class PatientsInitial extends PatientsState {}

class PatientsLoading extends PatientsState {}

class PatientsSuccess extends PatientsState {
  final PatientsResponse response;

  const PatientsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class PatientsError extends PatientsState {
  final String message;

  const PatientsError(this.message);

  @override
  List<Object> get props => [message];
}

