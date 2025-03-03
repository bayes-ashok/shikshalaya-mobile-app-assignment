import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/question_entity.dart';
import '../repository/quiz_repository.dart';


class GetQuestionsParams extends Equatable {
  final String quizSetId;

  const GetQuestionsParams({required this.quizSetId});

  @override
  List<Object?> get props => [quizSetId];
}

class GetQuestionsUseCase implements UsecaseWithParams<List<Question>, GetQuestionsParams> {
  final QuizRepository repository;

  GetQuestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Question>>> call(GetQuestionsParams params) {
    return repository.getQuestions(params.quizSetId);
  }
}


