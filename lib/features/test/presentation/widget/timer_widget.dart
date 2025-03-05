import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int totalTime; // Total quiz time in seconds
  final VoidCallback onTimeUp;

  const TimerWidget({super.key, required this.totalTime, required this.onTimeUp});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int remainingTime;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.totalTime;
    duration = Duration(seconds: remainingTime);
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && remainingTime > 0) {
        setState(() {
          remainingTime--;
          duration = Duration(seconds: remainingTime);
        });

        // Show alert when only 5 seconds are left
        if (remainingTime == 20) {
          _showTimeAlert();
        }

        startTimer();
      } else if (remainingTime == 0) {
        widget.onTimeUp(); // Auto-submit when time runs out
      }
    });
  }

  void _showTimeAlert() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing
      builder: (context) {
        return AlertDialog(
          title: const Text("Time is Almost Up!"),
          content: const Text("You only have 20 seconds left to complete the quiz."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  String _formatTime() {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        "Time Left: ${_formatTime()}",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: remainingTime <= 5 ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}
