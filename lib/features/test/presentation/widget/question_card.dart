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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7, // Prevent overflow
      ),
      child: Padding(
        padding: const EdgeInsets.all(16), // Keeps spacing consistent
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Question Text (No Background)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  question.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Text remains visible
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxWidth / 2, // Limits height dynamically
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 3,
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
                            backgroundColor = Colors.green.shade700;
                            borderColor = Colors.green.shade900;
                          } else if (isWrong) {
                            backgroundColor = Colors.red.shade700;
                            borderColor = Colors.red.shade900;
                          } else if (wasUnanswered) {
                            backgroundColor = correctAnswer == index ? Colors.green.shade700 : Colors.grey.shade200;
                            borderColor = correctAnswer == index ? Colors.green.shade900 : Colors.grey.shade500;
                          } else {
                            backgroundColor = Colors.grey.shade200;
                            borderColor = Colors.grey.shade500;
                          }
                        } else {
                          backgroundColor = isSelected ? Colors.blue.shade700 : Colors.grey.shade200;
                          borderColor = isSelected ? Colors.blue.shade900 : Colors.grey.shade500;
                        }

                        return GestureDetector(
                          onTap: reviewMode ? null : () => onAnswerSelected!(index),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                question.options[index],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
