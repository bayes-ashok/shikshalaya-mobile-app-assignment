import 'package:flutter/material.dart';
import 'package:shikshalaya/features/test/presentation/view/result_page.dart';

import '../../domain/entity/question_entity.dart';
import '../widget/question_card.dart';
import '../widget/quiz_navigation.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;

  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  Map<int, int?> selectedAnswers = {}; // Stores selected answer for each question

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = index;
    });
  }

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

  void _submitQuiz() {
    int correctAnswers = selectedAnswers.entries.where((entry) {
      int questionIndex = entry.key;
      int? selectedIndex = entry.value;
      return selectedIndex == widget.questions[questionIndex].correctAnswer;
    }).length;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(score: correctAnswers, total: widget.questions.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question ${currentQuestionIndex + 1}")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: QuestionCard(
                question: widget.questions[currentQuestionIndex],
                selectedAnswer: selectedAnswers[currentQuestionIndex],
                onAnswerSelected: _selectAnswer,
              ),
            ),
          ),
          QuestionNavigation(
            totalQuestions: widget.questions.length,
            currentIndex: currentQuestionIndex,
            onNext: _goToNext,
            onPrevious: _goToPrevious,
            onJumpTo: _jumpToQuestion,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _submitQuiz,
              child: const Text("Submit Quiz"),
            ),
          ),
        ],
      ),
    );
  }
}
