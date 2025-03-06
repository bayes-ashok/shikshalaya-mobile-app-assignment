import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/test/domain/entity/question_entity.dart';
import 'package:shikshalaya/features/test/domain/entity/quiz_set_entity.dart';
import 'package:shikshalaya/features/test/domain/use_case/get_questions_usecase.dart';
import 'package:shikshalaya/features/test/presentation/view_model/bloc/quiz_bloc.dart';

import '../../../../../../mocks.dart';

void main() {
  late QuizBloc quizBloc;
  late MockGetQuizSetsUseCase mockGetQuizSetsUseCase;
  late MockGetQuestionsUseCase mockGetQuestionsUseCase;

  setUp(() {
    mockGetQuizSetsUseCase = MockGetQuizSetsUseCase();
    mockGetQuestionsUseCase = MockGetQuestionsUseCase();

    quizBloc = QuizBloc(
      getQuizSetsUseCase: mockGetQuizSetsUseCase,
      getQuestionsUseCase: mockGetQuestionsUseCase,
    );

    registerFallbackValue(GetQuestionsParams(quizSetId: "quiz_001"));
  });

  test('initial state should be QuizState.initial()', () {
    expect(quizBloc.state, QuizState.initial());
  });

  final mockQuizSets = [
    QuizSet(
      id: "quiz_001",
      title: "General Knowledge",
      category: "GK",
      description: "Basic general knowledge questions.",
      createdAt: DateTime(2024, 3, 6),
    ),
  ];

  final mockQuestions = [
    Question(
      id: "q1",
      quizSetId: "quiz_001",
      question: "What is the capital of Nepal?",
      options: ["Kathmandu", "Pokhara", "Lalitpur", "Bhaktapur"],
      correctAnswer: 0,
    ),
  ];

  blocTest<QuizBloc, QuizState>(
    'emits [QuizState(isLoading: true), QuizState(isLoading: false, isSuccess: true, quizSets: mockQuizSets)] when LoadQuizSets is successful',
    build: () {
      when(() => mockGetQuizSetsUseCase())
          .thenAnswer((_) async => Right(mockQuizSets));
      return quizBloc;
    },
    act: (bloc) => bloc.add(LoadQuizSets()),
    expect: () => [
      QuizState(isLoading: true, isSuccess: false),
      QuizState(isLoading: false, isSuccess: true, quizSets: mockQuizSets),
    ],
  );

  blocTest<QuizBloc, QuizState>(
    'emits [QuizState(isLoading: true), QuizState(isLoading: false, isSuccess: false)] when LoadQuizSets fails',
    build: () {
      when(() => mockGetQuizSetsUseCase()).thenAnswer(
          (_) async => Left(ApiFailure(message: "Failed to load quiz sets")));
      return quizBloc;
    },
    act: (bloc) => bloc.add(LoadQuizSets()),
    expect: () => [
      QuizState(isLoading: true, isSuccess: false),
      QuizState(isLoading: false, isSuccess: false),
    ],
  );

  blocTest<QuizBloc, QuizState>(
    'emits [QuizState(isLoading: true), QuizState(isLoading: false, isSuccess: true, questions: mockQuestions)] when LoadQuestions is successful',
    build: () {
      when(() => mockGetQuestionsUseCase(any()))
          .thenAnswer((_) async => Right(mockQuestions));
      return quizBloc;
    },
    act: (bloc) => bloc.add(const LoadQuestions(quizSetId: "quiz_001")),
    expect: () => [
      QuizState(isLoading: true, isSuccess: false),
      QuizState(isLoading: false, isSuccess: true, questions: mockQuestions),
    ],
  );

  blocTest<QuizBloc, QuizState>(
    'emits [QuizState(isLoading: true), QuizState(isLoading: false, isSuccess: false)] when LoadQuestions fails',
    build: () {
      when(() => mockGetQuestionsUseCase(any())).thenAnswer(
          (_) async => Left(ApiFailure(message: "Failed to load questions")));
      return quizBloc;
    },
    act: (bloc) => bloc.add(const LoadQuestions(quizSetId: "quiz_001")),
    expect: () => [
      QuizState(isLoading: true, isSuccess: false),
      QuizState(isLoading: false, isSuccess: false),
    ],
  );
}
