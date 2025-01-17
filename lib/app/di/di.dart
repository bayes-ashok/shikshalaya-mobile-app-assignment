import 'package:get_it/get_it.dart';
import 'package:shikshalaya/core/network/hive_service.dart';
import 'package:shikshalaya/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:shikshalaya/features/auth/data/repository/auth_local_repository.dart';
import 'package:shikshalaya/features/auth/domain/use_case/login_usecase.dart';
import 'package:shikshalaya/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:shikshalaya/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:shikshalaya/features/test/presentation/view_model/bloc/test_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();

  await _initHomeDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initTestDependencies();

  // await _initSplashScreenDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initRegisterDependencies() {
  // init local data source
  getIt.registerLazySingleton(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  // init local repository
  getIt.registerLazySingleton(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );

  // register use usecase
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt(),
    ),
  );
}

_initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

_initLoginDependencies() async {
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthLocalRepository>(),
    ),
  );

  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}

_initTestDependencies() async{
  getIt.registerFactory<TestBloc>(
        () => TestBloc(),
  );
}

// _initSplashScreenDependencies() async {
//   getIt.registerFactory<SplashCubit>(
//     () => SplashCubit(getIt<LoginBloc>()),
//   );
// }
