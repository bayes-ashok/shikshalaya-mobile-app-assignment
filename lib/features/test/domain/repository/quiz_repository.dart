import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entity/question_entity.dart';
import '../entity/quiz_set_entity.dart';


abstract class QuizRepository {
  Future<Either<Failure, List<QuizSet>>> getQuizSets();
  Future<Either<Failure, List<Question>>> getQuestions(String quizSetId);
}
