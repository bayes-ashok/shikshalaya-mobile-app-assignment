

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/shared_prefs/token_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repository/course_repository.dart';

class IsEnrolledParams extends Equatable{
  final String courseId;

  const IsEnrolledParams({required this.courseId});

  @override
  // TODO: implement props
  List<Object?> get props => [courseId];
}

class IsEnrolledUseCase implements UsecaseWithParams<bool, IsEnrolledParams> {
  final ICourseRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  IsEnrolledUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, bool>> call(IsEnrolledParams params) async {
    final token = await tokenSharedPrefs.getToken();
    return token.fold((l) {
      return Left(l);
    }, (r) async {
      return repository.isEnrolled(params.courseId, r);
    });
  }
}