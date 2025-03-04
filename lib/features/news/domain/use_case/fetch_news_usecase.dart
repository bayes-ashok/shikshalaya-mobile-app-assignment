import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/news_entity.dart';
import '../repository/news_repository.dart';

class FetchNewsUseCase implements UsecaseWithoutParams<List<NewsEntity>> {
  final NewsRepository repository;

  FetchNewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call() async {
    return await repository.fetchNews();
  }
}
