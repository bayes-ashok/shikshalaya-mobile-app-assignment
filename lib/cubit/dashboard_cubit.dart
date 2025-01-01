import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/bloc/news_page_bloc.dart';
import 'package:shikshalaya/bloc/profile_page_bloc.dart';
import 'package:shikshalaya/bloc/test_page_bloc.dart';
import 'package:shikshalaya/view/news_screen.dart';
import 'package:shikshalaya/view/profile_screen.dart';
import 'package:shikshalaya/view/test_screen.dart';

class DashboardCubit extends Cubit<void> {
  DashboardCubit(
    this._testPageBloc,
    this._newsPageBloc,
    this._profilePageBloc,
  ) : super(null);

  final TestPageBloc _testPageBloc;
  final NewsPageBloc _newsPageBloc;
  final ProfilePageBloc _profilePageBloc;

  void openTestBlocView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => BlocProvider.value(
                value: _testPageBloc,
                child: TestScreen(),
              )),
    );
  }

  void openNewsBlocView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => BlocProvider.value(
                value: _newsPageBloc,
                child: NewsScreen(),
              )),
    );
  }

  void openProfileBlocView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => BlocProvider.value(
                value: _profilePageBloc,
                child: ProfileScreen(),
              )),
    );
  }
}
