import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/patients_repository.dart';
import 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  final PatientsRepository patientsRepository;

  PatientsCubit({required this.patientsRepository}) : super(PatientsInitial());

  int currentPage = 1;
  static const int pageSize = 10;

  /// Fetch patients with pagination
  Future<void> getPatients({int? page}) async {
    if (page != null) {
      currentPage = page;
    }
    
    emit(PatientsLoading());

    final result = await patientsRepository.getPatients(
      pageNumber: currentPage,
      pageSize: pageSize,
    );

    result.fold(
      (failure) => emit(PatientsError(failure.message)),
      (response) => emit(PatientsSuccess(response)),
    );
  }

  /// Navigate to next page
  void nextPage() {
    if (state is PatientsSuccess) {
      final successState = state as PatientsSuccess;
      final totalPages = (successState.response.count / pageSize).ceil();
      if (currentPage < totalPages) {
        getPatients(page: currentPage + 1);
      }
    }
  }

  /// Navigate to previous page
  void previousPage() {
    if (currentPage > 1) {
      getPatients(page: currentPage - 1);
    }
  }

  /// Navigate to specific page
  void goToPage(int page) {
    if (page != currentPage) {
      getPatients(page: page);
    }
  }
}

