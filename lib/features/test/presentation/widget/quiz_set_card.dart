import 'package:flutter/material.dart';
import '../../domain/entity/quiz_set_entity.dart';

class QuizSetCard extends StatelessWidget {
  final QuizSet quizSet;
  final VoidCallback onTap;

  const QuizSetCard({super.key, required this.quizSet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shadowColor: Colors.blueAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Icon(Icons.quiz, color: Colors.blueAccent, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  quizSet.title,
                  style: const TextStyle(
                      fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
