import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';

import '../../domain/entity/course_entity.dart';

abstract interface class ICourseDataSource{
  Future<CourseEntity> getCourseById(String courseId, String? token);

  Future<List<CourseEntity>> getAllCourses();

  Future<List<StudentCourseEntity>> getAllCoursesByStudent(String token);

  Future<bool> isEnrolled(String courseId, String studentId);
}