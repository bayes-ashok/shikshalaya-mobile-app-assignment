import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/test/domain/entity/quiz_set_entity.dart';
import 'package:shikshalaya/features/test/domain/use_case/get_quiz_sets_usecase.dart';

import '../../../../mocks.dart';

void main() {
  late GetQuizSetsUseCase usecase;
  late MockQuizRepository mockQuizRepository;

  setUp(() {
    mockQuizRepository = MockQuizRepository();
    usecase = GetQuizSetsUseCase(mockQuizRepository);
  });

  // Sample QuizSet Data
  final List<QuizSet> mockQuizSets = [
    QuizSet(
      id: "quiz_001",
      title: "General Knowledge",
      category: "GK",
      description: "Basic general knowledge questions.",
      createdAt: DateTime(2024, 3, 6),
    ),
    QuizSet(
      id: "quiz_002",
      title: "Mathematics",
      category: "Math",
      description: "Math-related questions for competitive exams.",
      createdAt: DateTime(2024, 2, 10),
    ),
  ];

  test('should return a list of quiz sets when repository call is successful',
      () async {
    // Arrange
    when(() => mockQuizRepository.getQuizSets())
        .thenAnswer((_) async => Right(mockQuizSets));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(mockQuizSets));
    verify(() => mockQuizRepository.getQuizSets()).called(1);
    verifyNoMoreInteractions(mockQuizRepository);
  });

  test('should return Failure when repository call fails', () async {
    // Arrange
    final failure = ApiFailure(message: "Failed to retrieve quiz sets");
    when(() => mockQuizRepository.getQuizSets())
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));
    verify(() => mockQuizRepository.getQuizSets()).called(1);
    verifyNoMoreInteractions(mockQuizRepository);
  });
}
