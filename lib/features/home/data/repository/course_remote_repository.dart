import 'package:dartz/dartz.dart';

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
      return Right(courses);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseEntity>> getCourseById(String courseId) async {
    try {
      final course = await _courseRemoteDataSource.getCourseById(courseId);
      return Right(course);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> enrollStudentInCourse(String courseId, String studentId) {
    // TODO: implement enrollStudentInCourse
    throw UnimplementedError();
  }

}
