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
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double cardWidth = isLandscape ? MediaQuery.of(context).size.width * 0.7 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Practice Tests"),
        backgroundColor: const Color(0xFFf0faff),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ProgressBar(
                currentIndex: currentQuestionIndex,
                total: widget.questions.length,
              ),
            ),

            // Timer Widget (Ensuring it doesn't take too much space)
            SizedBox(
              height: isLandscape ? 40 : 60,
              child: TimerWidget(
                totalTime: 60, // Total quiz time in seconds
                onTimeUp: _submitQuiz,
              ),
            ),

            // Question Card Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Left Arrow (Previous Button)
                    Positioned(
                      left: 5,
                      top: MediaQuery.of(context).size.height * (isLandscape ? 0.2 : 0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_left, size: 30, color: Colors.blueAccent),
                        onPressed: _goToPrevious,
                      ),
                    ),
                    // Right Arrow (Next Button)
                    Positioned(
                      right: 5,
                      top: MediaQuery.of(context).size.height * (isLandscape ? 0.2 : 0.3),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_right, size: 30, color: Colors.blueAccent),
                        onPressed: _goToNext,
                      ),
                    ),
                    // Centered Question Card with Responsive Width
                    Center(
                      child: SizedBox(
                        width: cardWidth,
                        child: QuestionCard(
                          question: widget.questions[currentQuestionIndex],
                          selectedAnswer: selectedAnswers[currentQuestionIndex],
                          onAnswerSelected: _selectAnswer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: QuizNavigation(
                totalQuestions: widget.questions.length,
                currentIndex: currentQuestionIndex,
                onNext: _goToNext,
                onPrevious: _goToPrevious,
                onJumpTo: _jumpToQuestion,
              ),
            ),

            // Submit Button (Ensuring Proper Width)
            Center(
              child: SizedBox(
                width: isLandscape ? cardWidth : double.infinity,
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                      color: Colors.white,
                    ),
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
