import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/core/common/bottom_nav.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_screen.dart';

import '../../../../app/di/di.dart';
import '../view_model/bloc/quiz_bloc.dart';
import '../widget/quiz_set_card.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
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

              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Small padding to avoid overlap
                child: BlocProvider(
                  create: (context) => getIt<QuizBloc>()..add(LoadQuizSets()),
                  child: BlocListener<QuizBloc, QuizState>(
                    listener: (context, state) {
                      if (state.isSuccess && state.questions != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPage(questions: state.questions!),
                          ),
                        );
                      }
                    },
                    child: BlocBuilder<QuizBloc, QuizState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state.isSuccess && state.quizSets != null) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(16), // Ensures spacing from edges
                            itemCount: state.quizSets!.length,
                            itemBuilder: (context, index) {
                              return QuizSetCard(
                                quizSet: state.quizSets![index],
                                onTap: () {
                                  context.read<QuizBloc>().add(
                                    LoadQuestions(quizSetId: state.quizSets![index].id),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text(
                              "No quizzes available",
                              style: TextStyle(color: Colors.black54, fontSize: 18),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const BottomNav(),
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
              overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
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
