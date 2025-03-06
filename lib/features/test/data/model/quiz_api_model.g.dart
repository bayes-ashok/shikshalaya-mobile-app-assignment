// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizSetModel _$QuizSetModelFromJson(Map<String, dynamic> json) => QuizSetModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$QuizSetModelToJson(QuizSetModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };
