import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/bloc/news_page_bloc.dart';
import 'package:shikshalaya/bloc/profile_page_bloc.dart';
import 'package:shikshalaya/bloc/test_page_bloc.dart';
import 'package:shikshalaya/view/home_page.dart';
import 'package:shikshalaya/view/news_screen.dart';
import 'package:shikshalaya/view/profile_screen.dart';
import 'package:shikshalaya/view/test_screen.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit(
    this._testPageBloc,
    this._newsPageBloc,
    this._profilePageBloc,
  ) : super(0);

  final TestPageBloc _testPageBloc;
  final NewsPageBloc _newsPageBloc;
  final ProfilePageBloc _profilePageBloc;

  void navigateTo(int index) {
    emit(index);
  }

  Widget getScreen(int index) {
    switch (index) {
      case 1:
        return BlocProvider.value(
          value: _testPageBloc,
          child: const TestScreen(),
        );
      case 2:
        return BlocProvider.value(
          value: _newsPageBloc,
          child: const NewsScreen(),
        );
      case 3:
        return BlocProvider.value(
          value: _profilePageBloc,
          child: const ProfileScreen(),
        );
      default:
        return const HomePage();
    }
  }
}
