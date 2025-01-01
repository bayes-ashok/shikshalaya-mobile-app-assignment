import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_page_event.dart';
part 'news_page_state.dart';

class NewsPageBloc extends Bloc<NewsPageEvent, NewsPageState> {
  NewsPageBloc() : super(NewsPageInitial()) {
    on<NewsPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
