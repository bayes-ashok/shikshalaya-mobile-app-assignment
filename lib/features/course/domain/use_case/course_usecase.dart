import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shikshalaya/app/shared_prefs/token_shared_prefs.dart';

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

class GetCourseByIdParams extends Equatable {
  final String courseId;

  const GetCourseByIdParams({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class GetCourseByIdUseCase implements UsecaseWithParams<CourseEntity, GetCourseByIdParams> {
  final ICourseRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;
  GetCourseByIdUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, CourseEntity>> call(GetCourseByIdParams params) async{
    final token = await tokenSharedPrefs.getToken();
    return token.fold((l){
      return Left(l);
    },(r) async{
      return repository.getCourseById(params.courseId,r);
    });
  }
}
