
// Event File: course_event.dart
part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}

class PrintCourseIdEvent extends CourseEvent {
  final String courseId;

  const PrintCourseIdEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class FetchCourseByIdEvent extends CourseEvent {
  final String courseId;

  const FetchCourseByIdEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}


class NavigateKhaltiDemoEvent extends CourseEvent {
  final BuildContext context;
  final CourseEntity course; // Keep courseId, remove destination

  const NavigateKhaltiDemoEvent({
    required this.context,
    required this.course,
  });

  @override
  List<Object> get props => [context, course];
}



class NavigateToVideoPlayerEvent extends CourseEvent {
  final BuildContext context;
  final String videoUrl;

  const NavigateToVideoPlayerEvent({
    required this.context,
    required this.videoUrl,
  });

  @override
  List<Object> get props => [context, videoUrl];
}

class CheckEnrollmentEvent extends CourseEvent {
  final String courseId;

  const CheckEnrollmentEvent(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class FetchStudentCoursesEvent extends CourseEvent {
  const FetchStudentCoursesEvent();
}
