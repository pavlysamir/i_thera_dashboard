import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_thera_dashboard/features/auth/data/models/login_request.dart';
import '../../../../core/cashe/cache_helper.dart';
import '../../../../core/cashe/cashe_constance.dart';
import '../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(LoginLoading());

    final request = LoginRequest(
      phoneNumber: phoneNumber,
      password: password,
      role: 0, // Hardcoded as per requirements/example
    );

    final result = await authRepository.login(request);

    result.fold((failure) => emit(LoginError(failure.message)), (
      response,
    ) async {
      if (response.token.isNotEmpty) {
        await CacheHelper.setSecureData(key: CacheConstants.token, value: response.token);
      }
      emit(LoginSuccess(response));
    });
  }
}
