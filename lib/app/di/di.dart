import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shikshalaya/app/shared_prefs/token_shared_prefs.dart';
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
import '../../features/course/presentation/view_model/bloc/course_bloc.dart';
import '../../features/payment/presentation/view_model/payment_bloc.dart';


final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();
  await _initApiService();
  await _initSharedPrefs();
  await _initHomeDependencies();
  await _initPaymentDependencies();
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


Future<void> _initSharedPrefs() async{
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(()=>sharedPrefs);
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

  getIt.registerLazySingleton(
        () => CourseRepository(getIt<CourseRemoteDataSource>()),
  );

  // Register the GetAllCoursesUseCase with the repository dependency
  getIt.registerLazySingleton<GetAllCoursesUseCase>(
        () => GetAllCoursesUseCase(repository: getIt<CourseRepository>()),
  );

  getIt.registerLazySingleton<GetCourseByIdUseCase>(
        () => GetCourseByIdUseCase(getIt<CourseRepository>(),
        getIt<TokenSharedPrefs>()),
  );


  getIt.registerLazySingleton<IsEnrolledUseCase>(
        () => IsEnrolledUseCase(getIt<CourseRepository>(),
        getIt<TokenSharedPrefs>()),
  );

  // Finally, register HomeCubit with the GetAllCoursesUseCase
  getIt.registerFactory<HomeCubit>(
        () => HomeCubit(getAllCoursesUseCase: getIt<GetAllCoursesUseCase>()),
  );

  // Register CourseBloc with its dependencies
  getIt.registerFactory<CourseBloc>(
        () => CourseBloc(getCourseByIdUseCase: getIt<GetCourseByIdUseCase>(),
        isEnrolledUseCase: getIt<IsEnrolledUseCase>(),
          paymentBloc: getIt<PaymentBloc>(),

        ),
  );

}
_initPaymentDependencies() async {
  getIt.registerLazySingleton<PaymentBloc>(() => PaymentBloc());
}



_initLoginDependencies() async {
  // getIt.registerLazySingleton<LoginUseCase>(
  //   () => LoginUseCase(
  //     getIt<AuthLocalRepository>(),
  //   ),
  // );

  getIt.registerLazySingleton<TokenSharedPrefs>(
      ()=> TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
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
