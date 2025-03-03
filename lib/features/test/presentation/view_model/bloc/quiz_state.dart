part of 'quiz_bloc.dart';

class QuizState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<QuizSet>? quizSets;
  final List<Question>? questions;

  const QuizState({
    required this.isLoading,
    required this.isSuccess,
    this.quizSets,
    this.questions,
  });

  factory QuizState.initial() {
    return const QuizState(
      isLoading: false,
      isSuccess: false,
      quizSets: null,
      questions: null,
    );
  }

  QuizState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<QuizSet>? quizSets,
    List<Question>? questions,
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      quizSets: quizSets ?? this.quizSets,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, quizSets, questions];
}
