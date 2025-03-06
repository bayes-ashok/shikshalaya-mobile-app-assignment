import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:shikshalaya/app/shared_prefs/token_shared_prefs.dart';
import 'package:shikshalaya/features/course/domain/entity/student_course_entity.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/course_entity.dart';
import '../repository/course_repository.dart';

class GetStudentCoursesUseCase implements UsecaseWithoutParams<List<StudentCourseEntity>> {
  final ICourseRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  GetStudentCoursesUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, List<StudentCourseEntity>>> call() async {
    // Retrieve token from shared preferences
    final token = await tokenSharedPrefs.getToken();

    return token.fold(
          (failure) => Left(failure),
          (validToken) async {
        return repository.getCourseByStudent(validToken);
      },
    );
  }
}
