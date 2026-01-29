import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:i_thera_dashboard/features/notification/data/data_sources/notification_remote_data_source.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_impl_repo.dart';
import 'package:i_thera_dashboard/features/notification/data/data_sources/push_notification_service.dart';
import 'package:i_thera_dashboard/features/notification/data/repositery/notification_repo.dart';
import 'package:i_thera_dashboard/features/notification/managers/cubit/notification_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/doctor_details_cubit/doctor_details_cubit.dart';
import 'package:i_thera_dashboard/features/notification/managers/wallet_request_cubit/cubit/wallet_request_cubit.dart';
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/manager/login_cubit.dart';
import '../../features/home/data/data_sources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/manager/home_cubit.dart';
import '../../features/patients/data/data_sources/patients_remote_data_source.dart';
import '../../features/patients/data/repositories/patients_repository.dart';
import '../../features/patients/data/repositories/patients_repository_impl.dart';
import '../../features/patients/manager/patients_cubit.dart';
import '../../features/patients/manager/patient_detail_cubit.dart';
import '../network/dio_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(() => LoginCubit(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Features - Home
  // Bloc
  sl.registerFactory(
    () => HomeCubit(homeRepository: sl(), patientsRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // Features - Patients
  // Bloc
  sl.registerFactory(() => PatientsCubit(patientsRepository: sl()));

  // Repository
  sl.registerLazySingleton<PatientsRepository>(
    () => PatientsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<PatientsRemoteDataSource>(
    () => PatientsRemoteDataSourceImpl(),
  );

  sl.registerFactory(
      () => PatientDetailCubit(patientsRepository: sl()));

  // Core
  sl.registerLazySingleton<Dio>(
    () => DioHelper.dio,
  ); // Assumes DioHelper.init() is called, or modify setup

  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(),
  );

  // Repositories
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl<NotificationsRemoteDataSource>(),
    ),
  );

  // Cubits
  sl.registerFactory(
    () => NotificationsCubit(
      notificationsRepository: sl<NotificationsRepository>(),
      pushNotificationService: sl<PushNotificationService>(),
    ),
  );

  sl.registerFactory(
    () => DoctorDetailCubit(
      notificationsRepository: sl<NotificationsRepository>(),
      pushNotificationService: sl<PushNotificationService>(),

    ),
  );

  sl.registerFactory(
    () => WalletRequestCubit(
      notificationsRepository: sl<NotificationsRepository>(),
      pushNotificationService: sl<PushNotificationService>(),

    ),
  );
}
