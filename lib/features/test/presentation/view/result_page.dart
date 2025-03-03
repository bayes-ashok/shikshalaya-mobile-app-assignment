import 'package:flutter/material.dart';
import 'quiz_sets_page.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int total;

  const ResultPage({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score: $score / $total",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the quiz set list
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizSetsPage()),
                );
              },
              child: const Text("Back to Quiz Sets"),
            ),
          ],
        ),
      ),
    );
  }
}
