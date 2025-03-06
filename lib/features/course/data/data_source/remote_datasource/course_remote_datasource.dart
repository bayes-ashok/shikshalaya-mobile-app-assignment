import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shikshalaya/features/course/data/data_source/course_data_source.dart';

import '../../../../../app/constants/api_endpoints.dart';
import '../../../domain/entity/course_entity.dart';
import '../../../domain/entity/student_course_entity.dart';
import '../../model/course_api_model.dart' show CourseApiModel;
import '../../model/student_course_api_model.dart';

class CourseRemoteDataSource implements ICourseDataSource {
  final Dio _dio;

  CourseRemoteDataSource(this._dio);

  @override
  Future<List<CourseEntity>> getAllCourses() async {
    try {
      Response response = await _dio.get(ApiEndpoints.getCourse);

      print(
          "Full Response: ${jsonEncode(response.data)}"); // Log the full JSON data

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
      Response response =
          await _dio.get("${ApiEndpoints.getCourseById}/$courseId");

      print(
          "hancy ko Response: ${jsonEncode(response.data)}"); // Log the full JSON data

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
  Future<bool> isEnrolled(String courseId, String token) async {
    try {
      // Fetch user details using token
      final authResponse = await _dio.get(
        ApiEndpoints.authCheck,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (authResponse.statusCode == 200) {
        var userData = authResponse.data['data']['user'];

        if (userData != null && userData is Map<String, dynamic>) {
          String userId = userData['_id'];
          print("User ID: $userId");

          // Check enrollment status (No headers needed)
          final enrollResponse =
              await _dio.get("${ApiEndpoints.purchaseInfo}/$courseId/$userId");

          if (enrollResponse.statusCode == 200) {
            return enrollResponse.data['data'] ?? false;
          } else {
            throw Exception(
                "Failed to check enrollment: ${enrollResponse.statusMessage}");
          }
        } else {
          throw Exception("Invalid user data format");
        }
      } else {
        throw Exception(
            "Failed to authenticate user: ${authResponse.statusMessage}");
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
  Future<List<StudentCourseEntity>> getAllCoursesByStudent(String token) async {
    try {
      // Step 1: Get User ID using the token
      final authResponse = await _dio.get(
        ApiEndpoints.authCheck,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (authResponse.statusCode == 200) {
        var userData = authResponse.data['data']['user'];

        if (userData != null &&
            userData is Map<String, dynamic> &&
            userData.containsKey('_id')) {
          String userId = userData['_id'];
          print("User ID: $userId");

          // Step 2: Fetch Courses for the Student
          final response =
              await _dio.get("${ApiEndpoints.getCourseByStudent}/$userId");

          print("Full Response: ${jsonEncode(response.data)}"); // Debugging log

          if (response.statusCode == 200) {
            var courseData =
                response.data != null && response.data is Map<String, dynamic>
                    ? response.data['data']
                    : null;

            if (courseData == null || courseData is! List) {
              throw Exception(
                  "Invalid response structure: Missing or incorrect 'data' field");
            }

            if (courseData.isEmpty) {
              print("No courses found for this student.");
              return [];
            }

            List<StudentCourseEntity> courses = [];

            for (var course in courseData) {
              if (course is Map<String, dynamic>) {
                try {
                  final courseApiModel = StudentCourseApiModel.fromJson(
                      course); // ✅ Changed from CourseApiModel
                  courses.add(courseApiModel
                      .toEntity()); // ✅ Convert to StudentCourseEntity
                } catch (e) {
                  print("Error converting course: $course | Error: $e");
                }
              } else {
                print("Unexpected course format: $course");
              }
            }

            return courses;
          } else {
            throw Exception(
                "Failed to fetch student courses: ${response.statusCode} - ${response.statusMessage}");
          }
        } else {
          throw Exception("Invalid user data format or missing user ID");
        }
      } else {
        throw Exception(
            "Failed to authenticate user: ${authResponse.statusMessage}");
      }
    } on DioException catch (e) {
      print("Dio error: ${e.message}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception("Unexpected error: $e");
    }
  }
}
