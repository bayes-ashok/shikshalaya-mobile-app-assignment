import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/core/common/bottom_nav.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_screen.dart';

import '../../../../app/di/di.dart';
import '../view_model/bloc/quiz_bloc.dart';
import '../widget/quiz_set_card.dart';

class QuizSetsPage extends StatelessWidget {
  const QuizSetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<QuizBloc>()..add(LoadQuizSets()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Test"),
          backgroundColor: Color(0xFFf0faff),
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
              colors: [Color(0xFFf0faff), Color(0xFFe6f7ff)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
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
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(), // Smooth scrolling
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32.0),
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


                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search Here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Filter Chips
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            FilterChipWidget(label: "Officer"),
                            FilterChipWidget(label: "Nayab Subba"),
                            FilterChipWidget(label: "Kharidar"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quiz Sets List - Must be inside Expanded to prevent overflow
                      state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (state.isSuccess && state.quizSets != null)
                          ? ListView.builder(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true, // Prevents overflow
                        physics: const NeverScrollableScrollPhysics(), // Disable extra scroll inside `SingleChildScrollView`
                        itemCount: state.quizSets!.length,
                        itemBuilder: (context, index) {
                          return QuizSetCard(
                            quizSet: state.quizSets![index],
                            onTap: () {
                              context.read<QuizBloc>().add(
                                LoadQuestions(
                                    quizSetId: state
                                        .quizSets![index].id),
                              );
                            },
                          );
                        },
                      )
                          : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "No quizzes available",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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
      backgroundColor: Colors.white,
    );
  }
}
