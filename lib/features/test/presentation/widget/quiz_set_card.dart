import 'package:flutter/material.dart';

import '../../domain/entity/quiz_set_entity.dart';

class QuizSetCard extends StatelessWidget {
  final QuizSet quizSet;
  final VoidCallback onTap;

  const QuizSetCard({super.key, required this.quizSet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(quizSet.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(quizSet.category),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
