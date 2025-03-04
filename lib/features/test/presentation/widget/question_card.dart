import 'package:flutter/material.dart';
import '../../domain/entity/question_entity.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedAnswer;
  final int? correctAnswer;
  final Function(int)? onAnswerSelected;
  final bool reviewMode;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    this.correctAnswer,
    this.onAnswerSelected,
    this.reviewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // ✅ Center the question
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            question.question,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // ✅ 2x2 matrix layout for options
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 3, // ✅ Adjust height of the options
          ),
          itemCount: question.options.length,
          itemBuilder: (context, index) {
            bool isSelected = selectedAnswer == index;
            bool isCorrect = correctAnswer == index;
            bool isWrong = isSelected && !isCorrect;
            bool wasUnanswered = selectedAnswer == null;

            Color backgroundColor;
            if (reviewMode) {
              if (isCorrect) {
                backgroundColor = Colors.green; // ✅ Correct Answer - Green
              } else if (isWrong) {
                backgroundColor = Colors.red; // ✅ Wrong Answer - Red
              } else if (wasUnanswered) {
                backgroundColor = correctAnswer == index ? Colors.green : Colors.grey[300]!; // ✅ Unanswered, show only correct answer in green
              } else {
                backgroundColor = Colors.grey[300]!; // Default for unselected
              }
            } else {
              backgroundColor = isSelected ? Colors.blue : Colors.grey[300]!;
            }

            return GestureDetector(
              onTap: reviewMode ? null : () => onAnswerSelected!(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor, // ✅ Change button background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    question.options[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // ✅ Ensure text is visible on colored backgrounds
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
