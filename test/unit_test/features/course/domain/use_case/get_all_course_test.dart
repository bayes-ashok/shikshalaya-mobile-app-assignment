import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/course_entity.dart';
import 'package:shikshalaya/features/course/domain/use_case/get_all_course.dart';

import '../../../../../mocks.dart';

void main() {
  late GetAllCoursesUseCase usecase;
  late MockCourseRepository mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepository();
    usecase = GetAllCoursesUseCase(repository: mockCourseRepository);
  });

  // Sample Loksewa Exam Course Data
  final List<CourseEntity> mockCourses = [
    CourseEntity(
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
      students: [
        StudentEntity(
          studentId: "stud_001",
          studentName: "Ram Bahadur",
          studentEmail: "ram@example.com",
          paidAmount: "1999.99",
        ),
      ],
      curriculum: [
        LectureEntity(
          title: "Introduction to Loksewa",
          videoUrl: "https://example.com/loksewa_intro.mp4",
          publicId: "lecture_001",
          freePreview: true,
        ),
      ],
      isPublished: true,
    ),
  ];

  test(
      'should return a list of Loksewa courses when repository returns success',
      () async {
    // Arrange
    when(() => mockCourseRepository.getAllCourses())
        .thenAnswer((_) async => Right(mockCourses));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(mockCourses));
    verify(() => mockCourseRepository.getAllCourses()).called(1);
    verifyNoMoreInteractions(mockCourseRepository);
  });

  test('should return a Failure when repository fails', () async {
    // Arrange
    final failure = ApiFailure(message: "Failed to load courses");
    when(() => mockCourseRepository.getAllCourses())
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockCourseRepository.getAllCourses()).called(1);
    verifyNoMoreInteractions(mockCourseRepository);
  });
}
