import 'package:equatable/equatable.dart';

class QuizSet extends Equatable {
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime createdAt;

  const QuizSet({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, category, description, createdAt];
}
