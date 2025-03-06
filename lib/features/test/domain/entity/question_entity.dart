import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String quizSetId;
  final String question;
  final List<String> options;
  final int correctAnswer;

  const Question({
    required this.id,
    required this.quizSetId,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [id, quizSetId, question, options, correctAnswer];
}
