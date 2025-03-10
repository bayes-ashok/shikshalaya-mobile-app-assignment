import 'package:dartz/dartz.dart';
import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entity/course_entity.dart';
import '../../domain/repository/course_repository.dart';
import '../../data/data_source/remote_datasource/course_remote_datasource.dart';

class CourseRepository implements ICourseRepository {
  final CourseRemoteDataSource _courseRemoteDataSource;

  CourseRepository(this._courseRemoteDataSource);

  @override
  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    try {
      final courses = await _courseRemoteDataSource.getAllCourses();
      print("courses: $courses");
      return Right(courses);
    } catch (e, stackTrace) {
      print("Error encountered: $e");
      print("Stack trace: $stackTrace");
      return Left(ApiFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, CourseEntity>> getCourseById(String courseId, String? token) async {
    try {
      final course = await _courseRemoteDataSource.getCourseById(courseId, token);
      return Right(course);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudentCourseEntity>>> getCourseByStudent(String token) async{
    try {
      final courses = await _courseRemoteDataSource.getAllCoursesByStudent(token);
      print("courses: $courses");
      return Right(courses);
    } catch (e, stackTrace) {
      print("Error encountered: $e");
      print("Stack trace: $stackTrace");
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isEnrolled(String courseId, String token) async{
    try {
      final course = await _courseRemoteDataSource.isEnrolled(courseId, token);
      return Right(course);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

}
