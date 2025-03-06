import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entity/news_entity.dart';

abstract interface class NewsDataSource {
  Future<List<NewsEntity>> fetchNews();
}
