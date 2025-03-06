import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/test/domain/entity/question_entity.dart';
import 'package:shikshalaya/features/test/domain/use_case/get_questions_usecase.dart';

import '../../../../mocks.dart';

void main() {
  late GetQuestionsUseCase usecase;
  late MockQuizRepository mockQuizRepository;

  setUp(() {
    mockQuizRepository = MockQuizRepository();
    usecase = GetQuestionsUseCase(mockQuizRepository);
  });

  // Sample QuizSet ID
  const String testQuizSetId = "quiz_001";

  // Sample Questions Data
  final List<Question> mockQuestions = [
    Question(
      id: "q1",
      quizSetId: testQuizSetId,
      question: "What is the capital of Nepal?",
      options: ["Kathmandu", "Pokhara", "Lalitpur", "Bhaktapur"],
      correctAnswer: 0, // Index of correct answer
    ),
    Question(
      id: "q2",
      quizSetId: testQuizSetId,
      question: "Which river is the longest in Nepal?",
      options: ["Bagmati", "Gandaki", "Koshi", "Karnali"],
      correctAnswer: 3,
    ),
  ];

  test('should return a list of questions when repository call is successful',
      () async {
    // Arrange
    when(() => mockQuizRepository.getQuestions(testQuizSetId))
        .thenAnswer((_) async => Right(mockQuestions));

    // Act
    final result =
        await usecase(const GetQuestionsParams(quizSetId: testQuizSetId));

    // Assert
    expect(result, Right(mockQuestions));
    verify(() => mockQuizRepository.getQuestions(testQuizSetId)).called(1);
    verifyNoMoreInteractions(mockQuizRepository);
  });

  test('should return Failure when repository call fails', () async {
    // Arrange
    final failure = ApiFailure(message: "Failed to retrieve questions");
    when(() => mockQuizRepository.getQuestions(testQuizSetId))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result =
        await usecase(const GetQuestionsParams(quizSetId: testQuizSetId));

    // Assert
    expect(result, Left(failure));
    verify(() => mockQuizRepository.getQuestions(testQuizSetId)).called(1);
    verifyNoMoreInteractions(mockQuizRepository);
  });
}
