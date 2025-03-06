import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/question_entity.dart';

part 'question_api_model.g.dart';

@JsonSerializable()
class QuestionModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'quizSetId')
  final String quizSetId;
  final String question;
  final List<String> options;
  final int correctAnswer;

  const QuestionModel({
    required this.id,
    required this.quizSetId,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  Question toEntity() {
    return Question(
      id: id,
      quizSetId: quizSetId,
      question: question,
      options: options,
      correctAnswer: correctAnswer,
    );
  }

  /// **Create Model from Entity**
  factory QuestionModel.fromEntity(Question entity) {
    return QuestionModel(
      id: entity.id,
      quizSetId: entity.quizSetId,
      question: entity.question,
      options: entity.options,
      correctAnswer: entity.correctAnswer,
    );
  }

  @override
  List<Object?> get props => [id, quizSetId, question, options, correctAnswer];
}
