import '../../domain/entity/course_entity.dart';

abstract interface class ICourseDataSource{
  Future<CourseEntity> getCourseById(String courseId, String? token);

  Future<List<CourseEntity>> getAllCourses();

  Future<void> enrollStudentInCourse(String courseId, String studentId);

  Future<bool> isEnrolled(String courseId, String studentId);
}