part of 'course_bloc.dart';

sealed class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class PrintCourseIdEvent extends CourseEvent {
  const PrintCourseIdEvent();

  @override
  List<Object> get props => [];
}

class NavigateKhaltiDemoEvent extends CourseEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateKhaltiDemoEvent({
    required this.context,
    required this.destination,
  });

  @override
  List<Object> get props => [context, destination];
}
