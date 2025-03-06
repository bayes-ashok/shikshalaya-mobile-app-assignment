import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';
import 'package:shikshalaya/features/course/domain/use_case/get_course_by_id_usecase.dart';
import 'package:shikshalaya/features/course/domain/use_case/is_enrolled_usecase.dart';
import 'package:shikshalaya/features/course/presentation/view_model/bloc/course_bloc.dart';

import '../../../../../../mocks.dart';

void main() {
  late CourseBloc courseBloc;
  late MockGetCourseByIdUseCase mockGetCourseByIdUseCase;
  late MockIsEnrolledUseCase mockIsEnrolledUseCase;
  late MockGetStudentCoursesUseCase mockGetStudentCoursesUseCase;
  late MockPaymentBloc mockPaymentBloc;

  setUp(() {
    mockGetCourseByIdUseCase = MockGetCourseByIdUseCase();
    mockIsEnrolledUseCase = MockIsEnrolledUseCase();
    mockGetStudentCoursesUseCase = MockGetStudentCoursesUseCase();
    mockPaymentBloc = MockPaymentBloc();

    courseBloc = CourseBloc(
      getCourseByIdUseCase: mockGetCourseByIdUseCase,
      isEnrolledUseCase: mockIsEnrolledUseCase,
      getStudentCoursesUseCase: mockGetStudentCoursesUseCase,
      paymentBloc: mockPaymentBloc,
    );

    registerFallbackValue(GetCourseByIdParams(courseId: "test_course"));
    registerFallbackValue(IsEnrolledParams(courseId: "test_course"));
  });

  test('initial state should be CourseInitial', () {
    expect(courseBloc.state, CourseInitial());
  });

  final mockCourse = CourseEntity(
    courseId: "test_course",
    instructorId: "inst_001",
    instructorName: "John Doe",
    date: DateTime(2024, 3, 6),
    title: "Test Course",
    category: "Education",
    level: "Beginner",
    primaryLanguage: "English",
    subtitle: "Intro to Testing",
    description: "A test course",
    image: "https://example.com/test.png",
    welcomeMessage: "Welcome to the test course!",
    pricing: 999.99,
    objectives: "Learn Testing",
    students: [],
    curriculum: [],
    isPublished: true,
  );

  final List<StudentCourseEntity> mockStudentCourses = [
    StudentCourseEntity(
      id: "student_course_001",
      courseId: "test_course",
      title: "Test Course",
      instructorId: "inst_001",
      instructorName: "John Doe",
      dateOfPurchase: DateTime(2024, 3, 6),
      image: "https://example.com/test.png",
    ),
  ];

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, CourseLoaded] when FetchCourseByIdEvent is successful',
    build: () {
      when(() => mockGetCourseByIdUseCase(any()))
          .thenAnswer((_) async => Right(mockCourse));
      return courseBloc;
    },
    act: (bloc) => bloc.add(FetchCourseByIdEvent("test_course")),
    expect: () => [
      CourseLoading(),
      CourseLoaded(course: mockCourse),
    ],
  );

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, CourseError] when FetchCourseByIdEvent fails',
    build: () {
      when(() => mockGetCourseByIdUseCase(any())).thenAnswer(
          (_) async => Left(ApiFailure(message: "Course not found")));
      return courseBloc;
    },
    act: (bloc) => bloc.add(FetchCourseByIdEvent("test_course")),
    expect: () => [
      CourseLoading(),
      const CourseError(message: "Something went wrong"),
    ],
  );

  blocTest<CourseBloc, CourseState>(
    'emits [CourseError] when CheckEnrollmentEvent fails',
    build: () {
      when(() => mockIsEnrolledUseCase(any())).thenAnswer(
          (_) async => Left(ApiFailure(message: "Enrollment check failed")));
      return courseBloc;
    },
    act: (bloc) => bloc.add(CheckEnrollmentEvent("test_course")),
    expect: () => [
      CourseError(message: "Something went wrong"),
    ],
  );

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, StudentCoursesLoaded] when FetchStudentCoursesEvent is successful',
    build: () {
      when(() => mockGetStudentCoursesUseCase())
          .thenAnswer((_) async => Right(mockStudentCourses));
      return courseBloc;
    },
    act: (bloc) => bloc.add(const FetchStudentCoursesEvent()),
    expect: () => [
      CourseLoading(),
      StudentCoursesLoaded(courses: mockStudentCourses),
    ],
  );

  blocTest<CourseBloc, CourseState>(
    'emits [CourseLoading, CourseError] when FetchStudentCoursesEvent fails',
    build: () {
      when(() => mockGetStudentCoursesUseCase()).thenAnswer(
          (_) async => Left(ApiFailure(message: "Failed to load courses")));
      return courseBloc;
    },
    act: (bloc) => bloc.add(const FetchStudentCoursesEvent()),
    expect: () => [
      CourseLoading(),
      const CourseError(message: "Something went wrong"),
    ],
  );
}
