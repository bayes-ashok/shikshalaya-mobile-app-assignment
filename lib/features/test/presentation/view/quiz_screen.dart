import 'package:flutter/material.dart';
import '../widget/progress_bar.dart';
import '../widget/question_card.dart';
import '../widget/quiz_navigation.dart';
import '../widget/timer_widget.dart';
import 'result_page.dart';
import '../../domain/entity/question_entity.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;

  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  Map<int, int?> selectedAnswers = {};

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
        builder: (context) => ResultPage(
          score: correctAnswers,
          total: widget.questions.length,
          questions: widget.questions,
          selectedAnswers: selectedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Question ${currentQuestionIndex + 1}"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          ProgressBar(currentIndex: currentQuestionIndex, total: widget.questions.length),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QuestionCard(
                  question: widget.questions[currentQuestionIndex],
                  selectedAnswer: selectedAnswers[currentQuestionIndex],
                  onAnswerSelected: _selectAnswer,
                ),
              ),
            ),
          ),
          QuizNavigation(
            totalQuestions: widget.questions.length,
            currentIndex: currentQuestionIndex,
            onNext: _goToNext,
            onPrevious: _goToPrevious,
            onJumpTo: _jumpToQuestion,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit Quiz", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
