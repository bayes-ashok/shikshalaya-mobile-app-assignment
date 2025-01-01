part of 'test_page_bloc.dart';

sealed class TestPageState extends Equatable {
  const TestPageState();
  
  @override
  List<Object> get props => [];
}

final class TestPageInitial extends TestPageState {}
