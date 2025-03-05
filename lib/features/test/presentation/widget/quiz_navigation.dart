import 'package:flutter/material.dart';

class QuizNavigation extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(int) onJumpTo;

  const QuizNavigation({
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
          spacing: 8,
          children: List.generate(
            totalQuestions,
                (index) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: index == currentIndex ? Colors.yellow : Colors.lightGreen,
              ),
              onPressed: () => onJumpTo(index),
              child: Text("${index + 1}"),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: currentIndex > 0 ? onPrevious : null,
              child: const Icon(Icons.arrow_back_ios),
            ),
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: currentIndex < totalQuestions - 1 ? onNext : null,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ],
    );
  }
}
