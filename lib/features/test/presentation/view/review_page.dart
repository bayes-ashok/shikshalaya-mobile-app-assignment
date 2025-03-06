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
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final double cardWidth = isLandscape ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Revieww Quiz", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Stack(
                  alignment: Alignment.center,
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
                    // Centered Question Card with Responsive Width
                    Center(
                      child: SizedBox(
                        width: cardWidth,
                        child: QuestionCard(
                          question: widget.questions[currentQuestionIndex],
                          selectedAnswer: widget.selectedAnswers[currentQuestionIndex],
                          correctAnswer: widget.questions[currentQuestionIndex].correctAnswer,
                          reviewMode: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
