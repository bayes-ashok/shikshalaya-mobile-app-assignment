import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/home/presentation/view/dashboard_view.dart';
import 'package:shikshalaya/features/home/presentation/view/home_view.dart';
import 'package:shikshalaya/features/news/presentation/view/news_screen.dart';
import 'package:shikshalaya/features/news/presentation/view_model/news_bloc.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_screen.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_sets_page.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';
import 'package:shikshalaya/features/test/presentation/view_model/bloc/quiz_bloc.dart';
import 'package:shikshalaya/features/user_profile/presentation/view/user_settings.dart';
import '../../../../../app/di/di.dart';
import '../../../../course/domain/entity/course_entity.dart';
import '../../../../user_profile/presentation/view_model/settings_bloc.dart';
import 'home_cubit.dart';
class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;
  final bool isLoading;
  final bool isSuccess;
  final bool isLoggingOut;
  final List<CourseEntity> courses;
  final List<CourseEntity> filteredCourses; // Filtered courses list
  final String? selectedCategory; // Selected category for filtering
  final String? errorMessage;

  const HomeState({
    required this.selectedIndex,
    required this.views,
    required this.isLoading,
    required this.isSuccess,
    required this.isLoggingOut,
    required this.courses,
    required this.filteredCourses,
    this.selectedCategory,
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
          create: (context) => getIt<NewsBloc>(),
          child: ScraperPage(),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsBloc>(),
          child: SettingsPage(),
        ),
      ],
      isLoading: false,
      isSuccess: false,
      courses: [],
      filteredCourses: [], // Initially same as courses
      selectedCategory: 'all', // Default to "all"
      errorMessage: null,
      isLoggingOut:false,

    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
    bool? isLoading,
    bool? isSuccess,
    bool? isLoggingOut,
    List<CourseEntity>? courses,
    List<CourseEntity>? filteredCourses,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      courses: courses ?? this.courses,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    views,
    isLoading,
    isSuccess,
    courses,
    filteredCourses,
    selectedCategory,
    errorMessage,
    isLoggingOut
  ];
}
