part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizSets extends QuizEvent {}

class LoadQuestions extends QuizEvent {
  final String quizSetId;

  const LoadQuestions({required this.quizSetId});

  @override
  List<Object?> get props => [quizSetId];
}
