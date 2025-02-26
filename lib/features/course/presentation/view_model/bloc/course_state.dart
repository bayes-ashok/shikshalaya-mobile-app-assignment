part of 'course_bloc.dart';

abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final CourseEntity course;

  const CourseLoaded({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseError extends CourseState {
  final String message;

  const CourseError({required this.message});

  @override
  List<Object> get props => [message];
}

class EnrollmentLoading extends CourseState {}

class EnrollmentChecked extends CourseState {
  final bool isEnrolled;

  const EnrollmentChecked({required this.isEnrolled});

  @override
  List<Object> get props => [isEnrolled];
}

class EnrollmentError extends CourseState {
  final String message;

  const EnrollmentError({required this.message});

  @override
  List<Object> get props => [message];
}

class EnrollmentCheckedState extends CourseState {
  final bool isEnrolled;
  const EnrollmentCheckedState({required this.isEnrolled});
}

