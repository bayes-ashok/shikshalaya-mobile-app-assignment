import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entity/news_entity.dart';
import '../../domain/use_case/fetch_news_usecase.dart';
import '../../../../core/error/failure.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchNewsUseCase fetchNewsUseCase;

  NewsBloc({required this.fetchNewsUseCase}) : super(NewsInitial()) {
    on<FetchNewsEvent>(_onFetchNews);
  }

  Future<void> _onFetchNews(FetchNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    final Either<Failure, List<NewsEntity>> result = await fetchNewsUseCase();

    result.fold(
          (failure) => emit(NewsError(failure.message)),
          (newsList) => emit(NewsLoaded(newsList)),
    );
  }
}
