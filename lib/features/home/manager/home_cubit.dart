import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/home_repository.dart';
import '../../patients/data/repositories/patients_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  final PatientsRepository patientsRepository;

  HomeCubit({
    required this.homeRepository,
    required this.patientsRepository,
  }) : super(HomeInitial());

  int currentPage = 1;
  static const int pageSize = 13;
  HomeTab currentTab = HomeTab.doctors;
  String searchQuery = '';

  Future<void> loadData({int? page}) async {
    if (page != null) {
      currentPage = page;
    }
    emit(HomeLoading());

    if (currentTab == HomeTab.doctors) {
      final result = await homeRepository.getDoctors(
        pageNumber: currentPage,
        pageSize: pageSize,
        doctorName: searchQuery.isEmpty ? null : searchQuery,
      );

      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (response) => emit(HomeLoaded(
          doctors: response,
          currentTab: currentTab,
        )),
      );
    } else {
      // Load patients
      final result = await patientsRepository.getPatients(
        pageNumber: currentPage,
        pageSize: pageSize,
        patientName: searchQuery.isEmpty ? null : searchQuery,
      );

      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (response) => emit(HomeLoaded(
          patients: response,
          currentTab: currentTab,
        )),
      );
    }
  }

  void search(String query) {
    searchQuery = query;
    currentPage = 1;
    loadData(page: 1);
  }

  void changeTab(HomeTab tab) {
    if (currentTab != tab) {
      currentTab = tab;
      currentPage = 1; // Reset to page 1 on tab change
      searchQuery = ''; // Reset search on tab change
      loadData(page: 1);
    }
  }

  void changePage(int page) {
    if (page != currentPage) {
      loadData(page: page);
    }
  }
}
