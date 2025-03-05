import 'package:dio/dio.dart';
import 'package:shikshalaya/app/constants/api_endpoints.dart';

import '../../model/question_api_model.dart';
import '../../model/quiz_api_model.dart';
import '../quiz_datasource.dart';



class QuizRemoteDataSource implements QuizDataSource {
  final Dio dio;

  QuizRemoteDataSource(this.dio);

  @override
  Future<List<QuizSetModel>> getQuizSets() async {
    try {
      final response = await dio.get(ApiEndpoints.getQuiz);

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => QuizSetModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to load quiz sets");
      }
    } catch (e) {
      throw Exception("Error fetching quiz sets: $e");
    }
  }

  @override
  Future<List<QuestionModel>> getQuestions(String quizSetId) async {
    try {
      final response = await dio.get("${ApiEndpoints.getQuestion}/$quizSetId");

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => QuestionModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to load questions");
      }
    } catch (e) {
      throw Exception("Error fetching questions: $e");
    }
  }
}
