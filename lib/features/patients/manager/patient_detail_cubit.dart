import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/patients_repository.dart';
import 'patient_detail_state.dart';

class PatientDetailCubit extends Cubit<PatientDetailState> {
  final PatientsRepository patientsRepository;

  PatientDetailCubit({required this.patientsRepository})
      : super(PatientDetailInitial());

  Future<void> suspendPatient(int userId, {required String note}) async {
    emit(PatientApprovalLoading());

    final result = await patientsRepository.approveOrDisapprove(
      userId: userId,
      role: 2, // 2 for patient
      isApproved: false,
      adminNote: note,
    );

    result.fold(
      (failure) => emit(PatientDetailError(failure.message)),
      (_) => emit(const PatientApprovalSuccess(isApproved: false)),
    );
  }
}
