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
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Better visibility for the question text
            ),
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
            Color borderColor;

            if (reviewMode) {
              if (isCorrect) {
                backgroundColor = Colors.green.shade700; // ✅ Correct Answer - Green
                borderColor = Colors.green.shade900; // Darker green for border
              } else if (isWrong) {
                backgroundColor = Colors.red.shade700; // ✅ Wrong Answer - Red
                borderColor = Colors.red.shade900; // Darker red for border
              } else if (wasUnanswered) {
                backgroundColor = correctAnswer == index ? Colors.green.shade700 : Colors.grey.shade200; // Lighter grey for unanswered
                borderColor = correctAnswer == index ? Colors.green.shade900 : Colors.grey.shade500; // Grey border for unanswered
              } else {
                backgroundColor = Colors.grey.shade200; // Default for unselected, lighter grey
                borderColor = Colors.grey.shade500; // Grey border for unselected
              }
            } else {
              backgroundColor = isSelected ? Colors.blue.shade700 : Colors.grey.shade200; // More subtle color when unselected
              borderColor = isSelected ? Colors.blue.shade900 : Colors.grey.shade500; // Border color for unselected options
            }

            return GestureDetector(
              onTap: reviewMode ? null : () => onAnswerSelected!(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor, // ✅ Change button background color
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 2), // Border for unselected options
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 4), // Changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    question.options[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87, // Ensures text visibility with background
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
