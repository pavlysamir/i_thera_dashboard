import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/doctor_details/data/repositories/doctor_details_repo_impl.dart';
import 'package:i_thera_dashboard/features/doctor_details/managers/cubit/doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final DoctorDetailsRepository repository;

  DoctorDetailsCubit({required this.repository}) : super(DoctorDetailsInitial());

  static DoctorDetailsCubit get(context) => BlocProvider.of(context);

  int _pageNumber = 1;
  final int _pageSize = 10;
  // Keep track of loaded data to restore after actions
  // Or better, just mutate the Loaded state.
  // Ideally, I should emit ActionLoading then restore Loaded.
  // But if I emit ActionLoading, the UI (Builder) might replace the list with a loader.
  // So I'll rely on BlocConsumer: Build on Loaded, Listen for Actions.
  // But standard Bloc usage: state drives UI.
  // I will emit Loaded with action flags if I want to show loading indicators inside the view,
  // OR I will trust the Listener to show dialogs/snackbars while the main view stays Loaded.
  // But if I emit a different state class, the Builder *will* rebuild.
  // So I should avoid emitting ActionLoading if I want to keep the view visible,
  // UNLESS the Builder handles it or I use a separate Cubit for actions.
  // For simplicity, I will emit DoctorDetailsActionLoading for actions and the UI might show a global loader is okay?
  // User request: "add balance from form field... stopped doctor...".
  // Let's use `DoctorDetailsLoaded` mainly.
  
  // Re-thinking: I defined ActionLoading disjoint from Loaded.
  // If I emit ActionLoading, the screen content disappears. That's bad.
  // I should probably hold the latest "Loaded" state in a variable and re-emit it?
  // Or better: Use separate states only for initialization, and keep Loaded for everything else?
  // But I need to signal "Success".
  
  // Alternative: `emit(state.copyWith(...))` if state is Loaded.
  // I'll stick to: Load Data -> Emit Loaded.
  // Action -> Emit Loaded(isLoadingAction: true) ?
  // My State definition has `DoctorDetailsActionLoading` separate. This implies full screen blocking.
  // I will change my approach:
  // Actions will NOT emit new states for the main Builder, unless necessary.
  // Actually, I can just reload the data after action.
  // Let's implement full reload `initDoctorDetails` after successful action,
  // and for the feedback, we can use `listenWhen` or just let the loading spinner appear.
  
  // Let's implement basic `init` and `loadMore`.

  Future<void> initDoctorDetails(int doctorId) async {
    emit(DoctorDetailsLoading());
    _pageNumber = 1;

    final doctorResult = await repository.getDoctorById(doctorId);
    
    doctorResult.fold(
      (failure) => emit(DoctorDetailsError(failure.message)),
      (doctor) async {
        // Fetch first page of transactions
        final transactionResult = await repository.getDoctorTransactions(
          doctorId: doctorId,
          pageNumber: _pageNumber,
          pageSize: _pageSize,
        );

        transactionResult.fold(
          (failure) => emit(DoctorDetailsError(failure.message)), // Or Loaded with error?
          (response) {
            emit(DoctorDetailsLoaded(
              doctor: doctor,
              transactions: response.items,
              hasReachedMax: response.items.length < _pageSize,
            ));
          },
        );
      },
    );
  }

  Future<void> loadMoreTransactions(int doctorId) async {
    if (state is DoctorDetailsLoaded) {
      final currentState = state as DoctorDetailsLoaded;
      if (currentState.hasReachedMax) return;

      final nextPage = _pageNumber + 1;
      
      // Ideally show loading footer. We don't emit Loading here effectively.
      // We could add `isMoreLoading` to Loaded state.
      
      final result = await repository.getDoctorTransactions(
        doctorId: doctorId,
        pageNumber: nextPage,
        pageSize: _pageSize,
      );

      result.fold(
        (failure) => null, // Handle pagination error (maybe snackbar)
        (response) {
          _pageNumber = nextPage;
          emit(currentState.copyWith(
            transactions: List.of(currentState.transactions)..addAll(response.items),
            hasReachedMax: response.items.length < _pageSize,
          ));
        },
      );
    }
  }

  Future<void> addBalance({
    required int doctorId,
    required num amount,
    required String description,
  }) async {
    // We want to keep displaying the screen.
    // Ideally use a separate Cubit for this form?
    // Or just emit a side-effect state?
    // If I emit `DoctorDetailsActionLoading`, the UI must handle it by NOT destroying the view,
    // possibly stacking a loader.
    // Or simpler: Show loader in UI, call this, await result? No, using Bloc.
    
    // I'll emit a "Loading" state for the listener, but the Builder might flicker?
    // The safest way with one Cubit that has disjoint states is to RE-EMIT the current Loaded state
    // with a flag, or just use a Stream for events.
    
    // I will assume for now that I can refresh the data.
    // But to show "Success!", I need to tell the UI.
    
    // Let's try this:
    // emit(ActionLoading) -> UI shows loader overlay.
    // emit(ActionSuccess) -> UI shows success, closes dialog.
    // emit(LoadData) -> Reload everything.
    
    // To preserve content behind loader, the UI usually checks `state is Loading` or `state is Loaded`.
    // Use `DoctorDetailsLoaded` with `actionStatus`.
    // But I already wrote the State class.
    // Let's handle it by just reloading for now to keep it robust.
    
    final result = await repository.addBalanceToDoctor(
      doctorId: doctorId,
      amount: amount,
      description: description,
    );

    result.fold(
      (failure) {
         emit(DoctorDetailsActionError(failure.message));
         // And then? Need to restore Loaded?
         // This is the problem with disjoint states.
         // I'll stick to reloading everything which restores state.
         initDoctorDetails(doctorId); 
      },
      (unit) {
        emit(const DoctorDetailsBalanceAddedSuccess("Balance added successfully"));
        initDoctorDetails(doctorId);
      },
    );
  }

  Future<void> approveOrDisapprove({
    required int doctorId,
    required int userId,
    required int role,
    required bool isApproved,
    String? adminNote,
  }) async {
    final result = await repository.approveOrDisapprove(
      userId: userId,
      role: role,
      isApproved: isApproved,
      adminNote: adminNote,
    );

    result.fold(
      (failure) {
        emit(DoctorDetailsActionError(failure.message));
        initDoctorDetails(doctorId);
      },
      (unit) {
        emit(DoctorDetailsApproveSuccess(isApproved));
        initDoctorDetails(doctorId);
      },
    );
  }
}
