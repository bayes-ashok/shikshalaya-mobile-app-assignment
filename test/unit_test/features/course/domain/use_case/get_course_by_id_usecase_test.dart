import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/course/domain/use_case/get_course_by_id_usecase.dart';

import '../../../../../mocks.dart';

void main() {
  late GetCourseByIdUseCase usecase;
  late MockCourseRepository mockCourseRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = GetCourseByIdUseCase(mockCourseRepository, mockTokenSharedPrefs);
  });

  // Sample Loksewa Exam Course Data
  final CourseEntity mockCourse = CourseEntity(
    courseId: "loksewa_001",
    instructorId: "inst_123",
    instructorName: "Prof. Sharma",
    date: DateTime(2024, 3, 6),
    title: "Loksewa Exam Preparation",
    category: "Government Exam",
    level: "Intermediate",
    primaryLanguage: "Nepali",
    subtitle: "Complete Guide to Loksewa",
    description: "This course prepares students for Loksewa Aayog exams.",
    image: "https://example.com/loksewa_image.png",
    welcomeMessage: "Welcome to the Loksewa Preparation Course!",
    pricing: 1999.99,
    objectives: "Learn all Loksewa syllabus, practice mock tests.",
    students: [],
    curriculum: [],
    isPublished: true,
  );

  const testParams = GetCourseByIdParams(courseId: "loksewa_001");

  test('should return course when repository successfully fetches it',
      () async {
    // Arrange
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right("valid_token"));

    when(() => mockCourseRepository.getCourseById("loksewa_001", "valid_token"))
        .thenAnswer((_) async => Right(mockCourse));

    // Act
    final result = await usecase(testParams);

    // Assert
    expect(result, Right(mockCourse));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verify(() =>
            mockCourseRepository.getCourseById("loksewa_001", "valid_token"))
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
    final result = await usecase(testParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyZeroInteractions(mockCourseRepository);
  });

  test('should return Failure when repository fails', () async {
    // Arrange
    final failure = ApiFailure(message: "Course not found");
    when(() => mockTokenSharedPrefs.getToken())
        .thenAnswer((_) async => Right("valid_token"));

    when(() => mockCourseRepository.getCourseById("loksewa_001", "valid_token"))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(testParams);

    // Assert
    expect(result, Left(failure));
    verify(() => mockTokenSharedPrefs.getToken()).called(1);
    verify(() =>
            mockCourseRepository.getCourseById("loksewa_001", "valid_token"))
        .called(1);
    verifyNoMoreInteractions(mockTokenSharedPrefs);
    verifyNoMoreInteractions(mockCourseRepository);
  });
}
