import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/course_entity.dart';
import '../repository/course_repository.dart';

class GetAllCoursesParams extends Equatable {
  const GetAllCoursesParams();

  @override
  List<Object> get props => [];
}

class GetAllCoursesUseCase implements UsecaseWithoutParams<List<CourseEntity>> {
  final ICourseRepository _repository;

  GetAllCoursesUseCase({required ICourseRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<CourseEntity>>> call() {
    return _repository.getAllCourses();
  }
}
