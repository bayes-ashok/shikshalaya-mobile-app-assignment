import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/home/presentation/view/dashboard_view.dart';
import 'package:shikshalaya/features/home/presentation/view/home_view.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_screen.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_sets_page.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';
import 'package:shikshalaya/features/test/presentation/view_model/bloc/quiz_bloc.dart';
import '../../../../../app/di/di.dart';
import '../../../../course/domain/entity/course_entity.dart';
import 'home_cubit.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;
  final bool isLoading;
  final bool isSuccess;
  final List<CourseEntity> courses;
  final String? errorMessage;

  const HomeState({
    required this.selectedIndex,
    required this.views,
    required this.isLoading,
    required this.isSuccess,
    required this.courses,
    this.errorMessage,
  });

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: DashboardView(),
        ),
        BlocProvider(
          create: (context) => getIt<QuizBloc>(),
          child: QuizSetsPage(),
        ),
        BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: DashboardView(),
        ),
        const Center(
          child: Text('Account'),
        ),
      ],
      isLoading: false,
      isSuccess: false,
      courses: [],
      errorMessage: null,
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
    bool? isLoading,
    bool? isSuccess,
    List<CourseEntity>? courses,
    String? errorMessage,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      courses: courses ?? this.courses,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views, isLoading, isSuccess, courses, errorMessage];
}
