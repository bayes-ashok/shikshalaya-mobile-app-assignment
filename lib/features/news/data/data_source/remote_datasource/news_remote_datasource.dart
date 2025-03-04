import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:shikshalaya/features/news/data/data_source/news_data_source.dart';

import '../../model/news_model.dart';


class NewsRemoteDataSource implements NewsDataSource {
  final Dio dio;

  NewsRemoteDataSource(this.dio);

  @override
  Future<List<NewsModel>> fetchNews() async {
    try {
      Response response = await dio.get('https://psc.gov.np/');
      var document = parse(response.data);
      List<NewsModel> newsList = [];

      var elements = document.querySelectorAll('ul.uk-list a');

      for (var element in elements) {
        String title = element.text.trim();
        String href = element.attributes['href'] ?? '#';
        if (!href.startsWith("http")) {
          href = "https://psc.gov.np$href";
        }
        newsList.add(NewsModel(title: title, url: href));
      }

      return newsList;
    } catch (e) {
      throw Exception("Failed to fetch news: $e");
    }
  }
}
