import 'package:get_it/get_it.dart';
import 'package:shikshalaya/bloc/news_page_bloc.dart';
import 'package:shikshalaya/bloc/profile_page_bloc.dart';
import 'package:shikshalaya/bloc/test_page_bloc.dart';
import 'package:shikshalaya/cubit/dashboard_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initCubit();
}

void _initCubit() {
  serviceLocator.registerLazySingleton<TestPageBloc>(() => TestPageBloc());
  serviceLocator.registerLazySingleton<NewsPageBloc>(() => NewsPageBloc());
  serviceLocator
      .registerLazySingleton<ProfilePageBloc>(() => ProfilePageBloc());

  serviceLocator.registerLazySingleton<DashboardCubit>(
    () => DashboardCubit(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );
}
