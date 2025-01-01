import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'test_page_event.dart';
part 'test_page_state.dart';

class TestPageBloc extends Bloc<TestPageEvent, TestPageState> {
  TestPageBloc() : super(TestPageInitial()) {
    on<TestPageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
