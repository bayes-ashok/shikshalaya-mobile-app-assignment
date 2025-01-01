import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.asset(
                    'assets/images/test.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Search Bar and Filter Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Here",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterChipWidget(label: "Officer"),
                  FilterChipWidget(label: "Nayab Subba"),
                  FilterChipWidget(label: "Kharidar"),
                ],
              ),
            ),

            // Quiz List Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quizzes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add navigation to see all
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
            // Use ListView to allow scrolling, one card per row horizontally
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                QuizCard(
                    title: "1st Paper | SECTION OFFICER – G.K.", questions: 50),
                QuizCard(
                    title: "1st Paper | SECTION OFFICER – I.Q.", questions: 30),
                QuizCard(
                    title: "1st Paper | SECTION OFFICER – English",
                    questions: 20),
                QuizCard(
                    title: "1st Paper | Nayab Subba – G.K.", questions: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;

  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool value) {},
      selected: false,
      backgroundColor: Colors.grey.shade200,
    );
  }
}

class QuizCard extends StatelessWidget {
  final String title;
  final int questions;

  const QuizCard({super.key, required this.title, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity, // Take full width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title text with maxLines to avoid overflow
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2, // Allow up to 2 lines
              overflow:
                  TextOverflow.ellipsis, // Add ellipsis if the text overflows
            ),
            SizedBox(height: 8),
            Text(
              "$questions Question${questions > 1 ? "s" : ""}",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
