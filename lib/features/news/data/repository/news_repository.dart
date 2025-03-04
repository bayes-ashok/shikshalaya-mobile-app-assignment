import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/news_entity.dart';
import '../../domain/repository/news_repository.dart';
import '../data_source/remote_datasource/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NewsEntity>>> fetchNews() async {
    try {
      final result = await remoteDataSource.fetchNews();
      return Right(result);
    } catch (e) {
      return Left(ApiFailure( message: e.toString()));
    }
  }
}
