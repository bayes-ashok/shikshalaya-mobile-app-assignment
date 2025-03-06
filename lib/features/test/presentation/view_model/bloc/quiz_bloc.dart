import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shikshalaya/features/test/presentation/view/quiz_screen.dart';
import '../../../../../app/di/di.dart';
import '../../../domain/entity/question_entity.dart';
import '../../../domain/entity/quiz_set_entity.dart';
import '../../../domain/use_case/get_questions_usecase.dart';
import '../../../domain/use_case/get_quiz_sets_usecase.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuizSetsUseCase _getQuizSetsUseCase;
  final GetQuestionsUseCase _getQuestionsUseCase;

  QuizBloc({
    required GetQuizSetsUseCase getQuizSetsUseCase,
    required GetQuestionsUseCase getQuestionsUseCase,
  })  : _getQuizSetsUseCase = getQuizSetsUseCase,
        _getQuestionsUseCase = getQuestionsUseCase,
        super(QuizState.initial()) {
    on<LoadQuizSets>(_onLoadQuizSets);
    on<LoadQuestions>(_onLoadQuestions);
  }

  void _onLoadQuizSets(
    LoadQuizSets event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getQuizSetsUseCase.call();

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (quizSets) {
        emit(state.copyWith(
            isLoading: false, isSuccess: true, quizSets: quizSets));
      },
    );
  }

  void _onLoadQuestions(
    LoadQuestions event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getQuestionsUseCase
        .call(GetQuestionsParams(quizSetId: event.quizSetId));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (questions) {
        emit(state.copyWith(
            isLoading: false, isSuccess: true, questions: questions));
        // Navigate to the quiz question screen
      },
    );
  }
}
