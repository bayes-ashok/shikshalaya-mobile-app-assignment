import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';
import 'package:shikshalaya/features/course/domain/use_case/get_student_course_usecase.dart';

import '../../../../../mocks.dart';

void main() {
  late GetStudentCoursesUseCase usecase;
  late MockCourseRepository mockCourseRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase =
        GetStudentCoursesUseCase(mockCourseRepository, mockTokenSharedPrefs);
  });

  // Sample Loksewa Student Courses Data (Updated Entity)
  final List<StudentCourseEntity> mockStudentCourses = [
    StudentCourseEntity(
      id: "student_course_001",
      courseId: "loksewa_001",
      title: "Loksewa Exam Preparation",
      instructorId: "inst_123",
      instructorName: "Prof. Sharma",
      dateOfPurchase: DateTime(2024, 3, 6),
      image: "https://example.com/loksewa_image.png",
    ),
    StudentCourseEntity(
      id: "student_course_002",
      courseId: "loksewa_002",
      title: "Advanced Loksewa Strategies",
      instructorId: "inst_456",
      instructorName: "Dr. Shrestha",
      dateOfPurchase: DateTime(2024, 2, 20),
      image: "https://example.com/loksewa_advanced.png",
    ),
  ];

  test(
      'should return list of student courses when repository call is successful',
      () async {
    // Arrange
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right("valid_token"));

    when(() => mockCourseRepository.getCourseByStudent("valid_token"))
        .thenAnswer((_) async => Right(mockStudentCourses));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(mockStudentCourses));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verify(() => mockCourseRepository.getCourseByStudent("valid_token"))
        .called(1);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockCourseRepository);
  });

  test('should return Failure when token retrieval fails', () async {
    // Arrange
    final failure = ApiFailure(message: "Failed to retrieve token");
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyZeroInteractions(mockCourseRepository);
  });

  test('should return Failure when repository call fails', () async {
    // Arrange
    final failure = ApiFailure(message: "Failed to retrieve student courses");
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right("valid_token"));

    when(() => mockCourseRepository.getCourseByStudent("valid_token"))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verify(() => mockCourseRepository.getCourseByStudent("valid_token"))
        .called(1);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockCourseRepository);
  });
}
