import 'package:flutter/material.dart';

class QuestionNavigation extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(int) onJumpTo;

  const QuestionNavigation({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onJumpTo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: List.generate(
            totalQuestions,
                (index) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: index == currentIndex ? Colors.orange : Colors.grey[300],
              ),
              onPressed: () => onJumpTo(index),
              child: Text("${index + 1}"),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: currentIndex > 0 ? onPrevious : null,
              child: const Text("Previous"),
            ),
            ElevatedButton(
              onPressed: currentIndex < totalQuestions - 1 ? onNext : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}
