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
        title: Text("Question ${currentQuestionIndex + 1}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 10,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ProgressBar(
                currentIndex: currentQuestionIndex,
                total: widget.questions.length,
              ),
            ),

            // Timer Widget
            TimerWidget(
              totalTime: 60, // Total quiz time in seconds
              onTimeUp: () {
                _submitQuiz();
              },
            ),

            // Question Card with Prev/Next Arrows
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Stack(
                  children: [
                    // Left Arrow (Previous Button)
                    Positioned(
                      left: 10,
                      top: MediaQuery.of(context).size.height * 0.3,
                      child: IconButton(
                        icon: Icon(Icons.arrow_left, size: 30, color: Colors.blueAccent),
                        onPressed: _goToPrevious,
                      ),
                    ),
                    // Right Arrow (Next Button)
                    Positioned(
                      right: 10,
                      top: MediaQuery.of(context).size.height * 0.3,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right, size: 30, color: Colors.blueAccent),
                        onPressed: _goToNext,
                      ),
                    ),
                    // Centered Question Card
                    Center(
                      child: QuestionCard(
                        question: widget.questions[currentQuestionIndex],
                        selectedAnswer: selectedAnswers[currentQuestionIndex],
                        onAnswerSelected: _selectAnswer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: QuizNavigation(
                totalQuestions: widget.questions.length,
                currentIndex: currentQuestionIndex,
                onNext: _goToNext,
                onPrevious: _goToPrevious,
                onJumpTo: _jumpToQuestion,
              ),
            ),

            // Submit Button (Blue with White Text)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for the button
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.blue,
                  elevation: 5,
                ),
                child: const Text(
                  "Submit Quiz",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
