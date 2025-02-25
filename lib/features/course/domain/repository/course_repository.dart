import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:shikshalaya/core/error/failure.dart';

import '../entity/course_entity.dart';

abstract interface class ICourseRepository {

  Future<Either<Failure, CourseEntity>> getCourseById(String courseId);

  Future<Either<Failure, List<CourseEntity>>> getAllCourses();

  Future<Either<Failure, void>> enrollStudentInCourse(String courseId, String studentId);

}
