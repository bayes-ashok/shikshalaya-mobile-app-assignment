import 'package:dio/dio.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../domain/entity/course_entity.dart';
import '../../dto/get_course_dto.dart';
import '../../model/course_api_model.dart' show CourseApiModel;


class CourseRemoteDataSource {
  final Dio _dio;

  CourseRemoteDataSource(this._dio);

  // Fetch all courses
  Future<List<CourseEntity>> getAllCourses() async {
    try {
      Response response = await _dio.get(ApiEndpoints.getCourse);

      if (response.statusCode == 200) {
        // Convert the API response to DTO
        var courseDTO = GetAllCourseDTO.fromJson(response.data);

        // Explicitly cast and map the data into a list of CourseApiModel
        List<CourseApiModel> courseApiModels = List<CourseApiModel>.from(
            courseDTO.data.map((x) => CourseApiModel.fromJson(x as Map<String, dynamic>))
        );

        // Map the DTO to the list of CourseEntities using the toEntityList method
        return CourseApiModel.toEntityList(courseApiModels);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }


  // Fetch a single course by ID
  Future<CourseEntity> getCourseById(String courseId) async {
    try {
      Response response = await _dio.get('${ApiEndpoints.getCourseById}/$courseId');

      if (response.statusCode == 200) {
        // Convert the API response to a CourseApiModel
        var courseApiModel = CourseApiModel.fromJson(response.data);
        // Convert the CourseApiModel to a CourseEntity
        return courseApiModel.toEntity();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
