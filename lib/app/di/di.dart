import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shikshalaya/core/network/api_service.dart';
import 'package:shikshalaya/core/network/hive_service.dart';
// import 'package:shikshalaya/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:shikshalaya/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:shikshalaya/features/auth/data/repository/auth_remote_repository.dart';
import 'package:shikshalaya/features/auth/domain/use_case/login_usecase.dart';
import 'package:shikshalaya/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:shikshalaya/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:shikshalaya/features/test/presentation/view_model/bloc/test_bloc.dart';
import '../../features/course/data/data_source/remote_datasource/course_remote_datasource.dart';
import '../../features/course/data/repository/course_remote_repository.dart';
import '../../features/course/domain/repository/course_repository.dart';
import '../../features/course/domain/use_case/course_usecase.dart';


final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();
  await _initApiService();
  await _initHomeDependencies();
  await _initRegisterDependencies();
  await _initLoginDependencies();
  await _initTestDependencies();

  // await _initSplashScreenDependencies();
}

_initHiveService() {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initRegisterDependencies() {
  // init local data source
  // getIt.registerLazySingleton(
  //   () => AuthLocalDataSource(getIt<HiveService>()),
  // );
  getIt.registerLazySingleton(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // init local repository
  // getIt.registerLazySingleton(
  //   () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  // );

  getIt.registerLazySingleton(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  // register use usecase
  // getIt.registerLazySingleton<RegisterUseCase>(
  //   () => RegisterUseCase(
  //     getIt<AuthLocalRepository>(),
  //   ),
  // );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(
      getIt<AuthRemoteRepository>(),
    ),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(() => UploadImageUsecase(
        getIt<AuthRemoteRepository>(),
      ));

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      registerUseCase: getIt(),
      uploadImagecase: getIt(),
    ),
  );
}
_initHomeDependencies() async {
  // Register CourseRemoteDataSource first (adjust constructor parameters as needed)
  getIt.registerLazySingleton<CourseRemoteDataSource>(
        () => CourseRemoteDataSource(getIt<Dio>()),
  );

  // Then, register the repository with its dependency
  getIt.registerLazySingleton<ICourseRepository>(
        () => CourseRepository(getIt<CourseRemoteDataSource>()),
  );

  // Register the GetAllCoursesUseCase with the repository dependency
  getIt.registerLazySingleton<GetAllCoursesUseCase>(
        () => GetAllCoursesUseCase(repository: getIt<ICourseRepository>()),
  );

  // Finally, register HomeCubit with the GetAllCoursesUseCase
  getIt.registerFactory<HomeCubit>(
        () => HomeCubit(getAllCoursesUseCase: getIt<GetAllCoursesUseCase>()),
  );
}



_initLoginDependencies() async {
  // getIt.registerLazySingleton<LoginUseCase>(
  //   () => LoginUseCase(
  //     getIt<AuthLocalRepository>(),
  //   ),
  // );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
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

_initTestDependencies() async {
  getIt.registerFactory<TestBloc>(
    () => TestBloc(),
  );
}

// _initSplashScreenDependencies() async {
//   getIt.registerFactory<SplashCubit>(
//     () => SplashCubit(getIt<LoginBloc>()),
//   );
// }
