
import '../../domain/entity/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({required super.title, required super.url});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(title: json['title'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }
}
