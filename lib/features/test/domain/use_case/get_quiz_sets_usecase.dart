import 'package:dartz/dartz.dart';

import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/quiz_set_entity.dart';
import '../repository/quiz_repository.dart';

class GetQuizSetsUseCase implements UsecaseWithoutParams<List<QuizSet>> {
  final QuizRepository repository;

  GetQuizSetsUseCase(this.repository);

  @override
  Future<Either<Failure, List<QuizSet>>> call() {
    return repository.getQuizSets();
  }
}
