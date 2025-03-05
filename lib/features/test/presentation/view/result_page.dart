import 'package:flutter/material.dart';
import 'quiz_sets_page.dart';
import 'review_page.dart';
import '../../domain/entity/question_entity.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int total;
  final List<Question> questions;
  final Map<int, int?> selectedAnswers;

  const ResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.questions,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (score / total) * 100;

    return WillPopScope(
      onWillPop: () async {
        // Prevents navigating back to the quiz page
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const QuizSetsPage()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white, // Set the background color to pure white
        appBar: AppBar(
          title: const Text("Quiz Result", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.lightBlue[50], // Light blue AppBar
          elevation: 0, // No elevation for clean look
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          foregroundColor: Colors.black,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity, // Ensure the body takes up full height
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFe1f5fe),
                Color(0xFFb3e5fc),
              ], // Light blue gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                // 🎯 Score Card (Square Shape with Full Width)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8, // More elevation for depth
                  child: Container(
                    width: double.infinity, // Full width
                    height: MediaQuery.of(context).size.width, // Height = width (square)
                    padding: const EdgeInsets.all(30), // Increased padding for bigger content
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Your Score",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: CircularProgressIndicator(
                                value: percentage / 100,
                                strokeWidth: 16,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation(
                                  percentage >= 50 ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            Text(
                              "$score / $total",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: percentage >= 50 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          percentage >= 50 ? "Well Done! 🎉" : "Keep Practicing! 💪",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🎯 Action Buttons (Consistent style)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const QuizSetsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5, // Soft shadow for the button
                      ),
                      child: const Text("Back to Quiz Sets", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPage(
                              questions: questions,
                              selectedAnswers: selectedAnswers,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 5, // Soft shadow for the button
                      ),
                      child: const Text("Review Quiz", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
