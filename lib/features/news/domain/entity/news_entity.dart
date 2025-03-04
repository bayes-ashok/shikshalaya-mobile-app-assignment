import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String title;
  final String url;

  const NewsEntity({required this.title, required this.url});

  @override
  List<Object?> get props => [title, url];
}
