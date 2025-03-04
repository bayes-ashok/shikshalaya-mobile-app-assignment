import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_screen.dart';

import '../../../../app/di/di.dart';
import '../view_model/bloc/quiz_bloc.dart';
import '../widget/quiz_set_card.dart';


class QuizSetsPage extends StatelessWidget {
  const QuizSetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select a Quiz"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocProvider(
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
                  padding: const EdgeInsets.all(16),
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
    );
  }
}
