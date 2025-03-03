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
      appBar: AppBar(title: const Text("Quiz Sets")),
      body: BlocProvider(
        create: (context) => getIt<QuizBloc>()..add(LoadQuizSets()),
        child: BlocConsumer<QuizBloc, QuizState>(
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
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isSuccess && state.quizSets != null) {
              return ListView.builder(
                itemCount: state.quizSets!.length,
                itemBuilder: (context, index) {
                  return QuizSetCard(
                    quizSet: state.quizSets![index],
                    onTap: () {
                      context.read<QuizBloc>().add(
                        LoadQuestions(
                          quizSetId: state.quizSets![index].id,
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text("No quizzes available"));
            }
          },
        ),
      ),
    );
  }
}
