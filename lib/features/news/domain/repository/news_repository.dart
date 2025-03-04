import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entity/news_entity.dart';

abstract interface class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> fetchNews();
}
