import 'package:equatable/equatable.dart';
import '../data/models/doctor_model.dart';
import '../data/models/paginated_response.dart';
import '../../patients/data/models/patients_response.dart';

enum HomeTab { doctors, patients }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final PaginatedResponse<DoctorModel>? doctors;
  final PatientsResponse? patients;
  final HomeTab currentTab;

  const HomeLoaded({
    this.doctors,
    this.patients,
    this.currentTab = HomeTab.doctors,
  });

  HomeLoaded copyWith({
    PaginatedResponse<DoctorModel>? doctors,
    PatientsResponse? patients,
    HomeTab? currentTab,
  }) {
    return HomeLoaded(
      doctors: doctors ?? this.doctors,
      patients: patients ?? this.patients,
      currentTab: currentTab ?? this.currentTab,
    );
  }

  // Helper getters for pagination
  int get currentPage => currentTab == HomeTab.doctors
      ? (doctors?.pageIndex ?? 1)
      : (patients?.pageIndex ?? 1);
  
  int get totalCount => currentTab == HomeTab.doctors
      ? (doctors?.count ?? 0)
      : (patients?.count ?? 0);
  
  int get pageSize => currentTab == HomeTab.doctors
      ? (doctors?.pageSize ?? 10)
      : (patients?.pageSize ?? 10);

  @override
  List<Object> get props => [
        doctors?.hashCode ?? 0,
        patients?.hashCode ?? 0,
        currentTab,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
