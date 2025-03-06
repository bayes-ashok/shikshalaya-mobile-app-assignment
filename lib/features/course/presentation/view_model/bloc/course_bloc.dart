import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';
import 'package:shikshalaya/features/payment/presentation/view_model/payment_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../../payment/presentation/view/khalti_screen.dart';
import '../../../domain/entity/course_entity.dart';
import '../../../domain/use_case/get_all_course.dart';
import '../../../domain/use_case/get_course_by_id_usecase.dart';
import '../../../domain/use_case/get_student_course_usecase.dart';
import '../../../domain/use_case/is_enrolled_usecase.dart';
import '../../view/video_player.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCourseByIdUseCase _getCourseByIdUseCase;
  final IsEnrolledUseCase _isEnrolledUseCase;
  final GetStudentCoursesUseCase _getStudentCoursesUseCase;
  final PaymentBloc _paymentBloc;

  CourseBloc({
    required GetCourseByIdUseCase getCourseByIdUseCase,
    required IsEnrolledUseCase isEnrolledUseCase,
    required GetStudentCoursesUseCase getStudentCoursesUseCase,
    required PaymentBloc paymentBloc,
  })  : _getCourseByIdUseCase = getCourseByIdUseCase,
        _isEnrolledUseCase = isEnrolledUseCase,
        _getStudentCoursesUseCase = getStudentCoursesUseCase,
        _paymentBloc = paymentBloc,
        super(CourseInitial()) {
    on<PrintCourseIdEvent>((event, emit) {
      print('CourseBloc: courseId is ${event.courseId}');
    });

    on<CheckEnrollmentEvent>((event, emit) async {
      print("Checking enrollment status for course ${event.courseId}");

      final result =
          await _isEnrolledUseCase(IsEnrolledParams(courseId: event.courseId));

      result.fold(
        (failure) {
          print("Enrollment check failed: ${_mapFailureToMessage(failure)}");
          emit(CourseError(message: _mapFailureToMessage(failure)));
        },
        (isEnrolled) {
          print("✅ Enrollment Status: $isEnrolled");
          emit(EnrollmentCheckedState(isEnrolled: isEnrolled));

          print("📌 Enrollment Check Completed! Fetching Course...");
          add(FetchCourseByIdEvent(event.courseId));
        },
      );
    });

    on<FetchCourseByIdEvent>((event, emit) async {
      print("Fetching course details...");
      emit(CourseLoading());

      final result = await _getCourseByIdUseCase(
          GetCourseByIdParams(courseId: event.courseId));

      result.fold(
        (failure) {
          print("Course fetch failed: ${_mapFailureToMessage(failure)}");
          emit(CourseError(message: _mapFailureToMessage(failure)));
        },
        (course) {
          print("✅ Course fetched successfully: ${course.title}");
          emit(CourseLoaded(course: course));
        },
      );
    });

    on<FetchStudentCoursesEvent>((event, emit) async {
      print("Fetching student courses...");
      emit(CourseLoading());

      final result = await _getStudentCoursesUseCase();

      result.fold(
        (failure) {
          print(
              "Fetching student courses failed: ${_mapFailureToMessage(failure)}");
          emit(CourseError(message: _mapFailureToMessage(failure)));
        },
        (courses) {
          print("✅ Student courses fetched successfully: ${courses.length}");
          emit(StudentCoursesLoaded(courses: courses));
        },
      );
    });

    on<NavigateKhaltiDemoEvent>((event, emit) {
      String pidx = "jWCEqw6u7YcrDxnQidYHBB";
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _paymentBloc,
            child: KhaltiSDKDemo(course: event.course, pidxx: pidx),
          ),
        ),
      );
      print("Generated pidx: $pidx");
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
    return 'Something went wrong';
  }
}
