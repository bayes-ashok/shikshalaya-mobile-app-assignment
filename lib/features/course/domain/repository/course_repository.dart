import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';
import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';

import '../entity/course_entity.dart';

abstract interface class ICourseRepository {
  Future<Either<Failure, CourseEntity>> getCourseById(
      String courseId, String? token);

  Future<Either<Failure, List<CourseEntity>>> getAllCourses();

  Future<Either<Failure, List<StudentCourseEntity>>> getCourseByStudent(
      String token);

  Future<Either<Failure, bool>> isEnrolled(String courseId, String token);
}
