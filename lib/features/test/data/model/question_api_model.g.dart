// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['_id'] as String,
      quizSetId: json['quizSetId'] as String,
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctAnswer: (json['correctAnswer'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'quizSetId': instance.quizSetId,
      'question': instance.question,
      'options': instance.options,
      'correctAnswer': instance.correctAnswer,
    };
