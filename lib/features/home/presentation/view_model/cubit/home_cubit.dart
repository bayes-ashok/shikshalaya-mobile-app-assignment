import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/app/di/di.dart';
import 'package:shikshalaya/features/auth/presentation/view/login_view.dart';
import 'package:shikshalaya/features/auth/presentation/view_model/login/login_bloc.dart';

import '../../../../course/domain/use_case/course_usecase.dart';
import '../../../../course/presentation/view/course_detail_page.dart';
import '../../../../course/presentation/view_model/bloc/course_bloc.dart';
import '../../../../payment/presentation/view_model/payment_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetAllCoursesUseCase getAllCoursesUseCase;

  HomeCubit({required this.getAllCoursesUseCase})
      : super(HomeState.initial()) {
    // Automatically fetch courses when the cubit is created.
    fetchCourses();
  }

  void fetchCourses() async {
    print("Fetching courses...");
    emit(state.copyWith(isLoading: true));

    final result = await getAllCoursesUseCase();
    result.fold(
          (failure) {
        print("Fetch failed: $failure");
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: "Failed to fetch courses",
        ));
      },
          (courses) {
        print("Fetched courses: ${courses.length}");

        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          courses: courses,
          filteredCourses: courses, // Ensure filtered list is initialized
          errorMessage: null,
        ));
      },
    );
  }

  void onTabTapped(int index) {
    print("Tab selected: $index");
    emit(state.copyWith(selectedIndex: index));
  }



  void navigateToCourseDetail(BuildContext context, String courseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<CourseBloc>()),
            BlocProvider.value(value: getIt<PaymentBloc>()),
          ],
          child: CourseDetailPage(courseId: courseId),
        ),
      ),
    );
  }

  void filterCoursesByLevel(String level) {
    print("Filtering by level: $level");
    emit(state.copyWith(selectedCategory: level));

    if (level == 'all') {
      emit(state.copyWith(filteredCourses: state.courses));
    } else {
      final filtered = state.courses.where((course) {
        print("Checking course: ${course.title}, Level: ${course.level}");
        return course.level == level;
      }).toList();

      print("Filtered courses: ${filtered.length}");

      emit(state.copyWith(filteredCourses: filtered));
    }
  }
}
