import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikshalaya/features/course/data/data_source/course_data_source.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../domain/entity/course_entity.dart';
import '../../dto/get_course_dto.dart';
import '../../model/course_api_model.dart' show CourseApiModel;


class CourseRemoteDataSource implements ICourseDataSource{
  final Dio _dio;

  CourseRemoteDataSource(this._dio);

  @override
  Future<List<CourseEntity>> getAllCourses() async {
    try {
      final response = await _dio.get("http://10.0.2.2:8000/student/course/get");

      print("Full Response: ${jsonEncode(response.data)}"); // Log the full JSON data

      if (response.statusCode == 200) {
        var courseData = response.data['data']; // Access the 'data' field

        if (courseData != null && courseData is List) {
          List<CourseEntity> courses = [];

          // Iterate over the course data list and convert each item
          for (var course in courseData) {
            // Ensure each course is a Map<String, dynamic> before conversion
            if (course is Map<String, dynamic>) {
              final courseApiModel = CourseApiModel.fromJson(course);
              courses.add(courseApiModel.toEntity());
            } else {
              print("Unexpected course format: $course");
            }
          }
          return courses;
        } else {
          throw Exception("Invalid course data format");
        }
      } else {
        throw Exception("Failed to fetch courses: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Dio error: $e");
      throw Exception(e);
    } catch (e) {
      print("Error here: $e");
      throw Exception(e);
    }
  }



  // Fetch a single course by ID
  @override
  Future<CourseEntity> getCourseById(String courseId, String? token) async {
    print("hancy is fetching course with ID: $token");
    try {
      final response = await _dio.get("http://10.0.2.2:8000/student/course/get/details/$courseId");

      print("hancy ko Response: ${jsonEncode(response.data)}"); // Log the full JSON data

      if (response.statusCode == 200) {
        var courseData = response.data['data']; // Access the 'data' field

        if (courseData != null && courseData is Map<String, dynamic>) {
          final courseApiModel = CourseApiModel.fromJson(courseData);
          return courseApiModel.toEntity();
        } else {
          throw Exception("Invalid course data format");
        }
      } else {
        throw Exception("Failed to fetch course: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print("Dio error: $e");
      throw Exception(e);
    } catch (e) {
      print("Error here: $e");
      throw Exception(e);
    }
  }

  @override
  Future<void> enrollStudentInCourse(String courseId, String studentId) {
    // TODO: implement enrollStudentInCourse
    throw UnimplementedError();
  }
}
