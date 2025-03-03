import '../model/question_api_model.dart';
import '../model/quiz_api_model.dart';

abstract class QuizDataSource {
  Future<List<QuizSetModel>> getQuizSets();
  Future<List<QuestionModel>> getQuestions(String quizSetId);
}