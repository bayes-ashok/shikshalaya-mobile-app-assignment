import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/course_entity.dart';
import '../../../domain/use_case/course_usecase.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourseByIdUseCase _getCourseByIdUseCase;

  CourseBloc({
    required GetCourseByIdUseCase getCourseByIdUseCase,
  })  : _getCourseByIdUseCase = getCourseByIdUseCase,
        super(CourseInitial()) {

    on<PrintCourseIdEvent>((event, emit) {
      print('CourseBloc: courseId is ${event.courseId}');
    });

    on<FetchCourseByIdEvent>((event, emit) async {
      print("check check");
      emit(CourseLoading());
      final result = await _getCourseByIdUseCase(GetCourseByIdParams(courseId: event.courseId));

      result.fold(
            (failure) => emit(CourseError(message: _mapFailureToMessage(failure))),
            (course) {
          print("Fetched Course: $course"); // Print the fetched course
          emit(CourseLoaded(course: course));
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
  }

  String _mapFailureToMessage(Failure failure) {
    print("fail error");
    return 'Something went wrong';
  }
}