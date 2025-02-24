import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/app/di/di.dart';
import 'package:shikshalaya/features/auth/presentation/view/login_view.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/login/login_bloc.dart';

import '../../../../course/presentation/view/course_detail_page.dart';
import '../../../../course/presentation/view_model/bloc/course_bloc.dart';
import '../../../domain/use_case/course_usecase.dart';
import 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  final GetAllCoursesUseCase getAllCoursesUseCase;

  HomeCubit({required this.getAllCoursesUseCase})
      : super(HomeState.initial()) {
    // Automatically fetch courses when the cubit is created.
    fetchCourses();
  }

  void fetchCourses() async {
    print("fetched");
    emit(state.copyWith(isLoading: true));
    final result = await getAllCoursesUseCase();
    result.fold(
          (failure) {
            print(failure);
            emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: "Failed to fetch courses",
        ));
      },
          (courses) {
            print("courses $courses");

            emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          courses: courses,
          errorMessage: null,
        ));
      },
    );
  }


  // Keep the onTabTapped method as provided.
  void onTabTapped(int index) {
    print(index);
    emit(state.copyWith(selectedIndex: index));
  }

  // Optional: Include logout functionality if needed.
  void logout(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: getIt<LoginBloc>(),
              child: LoginView(),
            ),
          ),
        );
      }
    });
  }

  void navigateToCourseDetail(BuildContext context, String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CourseBloc(courseId: courseId),
          child: CourseDetailPage(), // CourseDetailPage no longer requires courseId in its constructor.
        ),
      ),
    );
  }
}
