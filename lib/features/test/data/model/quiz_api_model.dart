import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/quiz_set_entity.dart';

part 'quiz_api_model.g.dart';

@JsonSerializable()
class QuizSetModel extends Equatable {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String category;
  final String? description;
  final DateTime createdAt;

  const QuizSetModel({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    required this.createdAt,
  });

  factory QuizSetModel.fromJson(Map<String, dynamic> json) =>
      _$QuizSetModelFromJson(json);

  /// **Convert to JSON**
  Map<String, dynamic> toJson() => _$QuizSetModelToJson(this);

  QuizSet toEntity() {
    return QuizSet(
      id: id,
      title: title,
      category: category,
      description: description ?? "",
      createdAt: createdAt,
    );
  }

  factory QuizSetModel.fromEntity(QuizSet entity) {
    return QuizSetModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, title, category, description, createdAt];
}
