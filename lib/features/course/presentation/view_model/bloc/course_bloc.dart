import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/course_entity.dart';
import '../../../domain/use_case/course_usecase.dart';
import '../../view/video_player.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourseByIdUseCase _getCourseByIdUseCase;
  final IsEnrolledUseCase _isEnrolledUseCase;

  CourseBloc({
    required GetCourseByIdUseCase getCourseByIdUseCase,
    required IsEnrolledUseCase isEnrolledUseCase,
  })  : _getCourseByIdUseCase = getCourseByIdUseCase,
        _isEnrolledUseCase = isEnrolledUseCase,
        super(CourseInitial()) {

    on<PrintCourseIdEvent>((event, emit) {
      print('CourseBloc: courseId is ${event.courseId}');
    });

    on<CheckEnrollmentEvent>((event, emit) async {
      print("Checking enrollment status for course ${event.courseId}");

      final result = await _isEnrolledUseCase(IsEnrolledParams(courseId: event.courseId));

      result.fold(
            (failure) {
          print("Enrollment check failed: ${_mapFailureToMessage(failure)}");
          emit(CourseError(message: _mapFailureToMessage(failure))); // ✅ Handle error
        },
            (isEnrolled) {
          print("✅ Enrollment Status: $isEnrolled");
          emit(EnrollmentCheckedState(isEnrolled: isEnrolled));

          // ✅ Step 2: Now fetch course details
          print("📌 Enrollment Check Completed! Fetching Course...");
          add(FetchCourseByIdEvent(event.courseId));
        },
      );
    });

    on<FetchCourseByIdEvent>((event, emit) async {
      print("Fetching course details...");

      emit(CourseLoading()); // ✅ Show loading state before fetching

      final result = await _getCourseByIdUseCase(GetCourseByIdParams(courseId: event.courseId));

      result.fold(
            (failure) {
          print("Course fetch failed: ${_mapFailureToMessage(failure)}");
          emit(CourseError(message: _mapFailureToMessage(failure))); // ✅ Handle failure
        },
            (course) {
          print("✅ Course fetched successfully: ${course.title}");
          emit(CourseLoaded(course: course)); // ✅ Emit CourseLoaded
        },
      );
    });



    on<NavigateKhaltiDemoEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => event.destination,
        ),
      );
    });


    on<NavigateToVideoPlayerEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoUrl: event.videoUrl),
        ),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    print("fail error");
    return 'Something went wrong';
  }
}