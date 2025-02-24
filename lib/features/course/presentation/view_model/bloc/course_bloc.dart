import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final String courseId;

  CourseBloc({required this.courseId}) : super(CourseInitial()) {
    // Automatically dispatch an event to print the courseId.

    on<PrintCourseIdEvent>((event, emit) {
      print('CourseBloc: courseId is $courseId');
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
}
