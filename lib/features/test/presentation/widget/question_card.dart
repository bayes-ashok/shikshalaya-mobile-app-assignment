import 'package:flutter/material.dart';
import '../../domain/entity/question_entity.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedAnswer;
  final Function(int) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(question.options.length, (index) {
              bool isSelected = selectedAnswer == index;
              return GestureDetector(
                onTap: () => onAnswerSelected(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[300], // ✅ Updated BG color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    question.options[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black, // ✅ Ensure text is visible
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
