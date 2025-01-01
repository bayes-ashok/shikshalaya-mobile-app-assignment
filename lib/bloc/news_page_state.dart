part of 'news_page_bloc.dart';

sealed class NewsPageState extends Equatable {
  const NewsPageState();
  
  @override
  List<Object> get props => [];
}

final class NewsPageInitial extends NewsPageState {}
