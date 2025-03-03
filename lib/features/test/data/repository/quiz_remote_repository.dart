import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/question_entity.dart';
import '../../domain/entity/quiz_set_entity.dart';
import '../../domain/repository/quiz_repository.dart';
import '../data_source/remote_datasource/quiz_remote_data_source.dart';
import '../model/question_api_model.dart';
import '../model/quiz_api_model.dart';


class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<QuizSet>>> getQuizSets() async {
    try {
      final List<QuizSetModel> quizSetModels = await remoteDataSource.getQuizSets();
      final List<QuizSet> quizSets = quizSetModels.map((model) => model.toEntity()).toList();
      return Right(quizSets);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions(String quizSetId) async {
    try {
      final List<QuestionModel> questionModels = await remoteDataSource.getQuestions(quizSetId);
      final List<Question> questions = questionModels.map((model) => model.toEntity()).toList();
      return Right(questions);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}

