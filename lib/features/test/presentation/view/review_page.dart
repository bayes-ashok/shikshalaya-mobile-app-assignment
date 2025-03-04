import 'package:flutter/material.dart';
import '../widget/question_card.dart';
import '../../domain/entity/question_entity.dart';
import '../widget/quiz_navigation.dart';

class ReviewPage extends StatefulWidget {
  final List<Question> questions;
  final Map<int, int?> selectedAnswers;

  const ReviewPage({super.key, required this.questions, required this.selectedAnswers});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int currentQuestionIndex = 0;

  void _goToNext() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _goToPrevious() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _jumpToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Quiz")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: QuestionCard(
                    question: widget.questions[currentQuestionIndex],
                    selectedAnswer: widget.selectedAnswers[currentQuestionIndex],
                    correctAnswer: widget.questions[currentQuestionIndex].correctAnswer,
                    reviewMode: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // ✅ Extra space before navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20), // ✅ Moves navigation buttons up
              child: QuizNavigation(
                totalQuestions: widget.questions.length,
                currentIndex: currentQuestionIndex,
                onNext: _goToNext,
                onPrevious: _goToPrevious,
                onJumpTo: _jumpToQuestion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
