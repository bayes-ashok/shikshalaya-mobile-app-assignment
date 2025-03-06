import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/features/home/presentation/view/dashboard_view.dart';
import 'package:shikshalaya/features/home/presentation/view/home_view.dart';
import 'package:shikshalaya/features/home/presentation/view_model/cubit/home_cubit.dart';
import 'package:shikshalaya/features/test/presentation/view/test_screen.dart';

import '../../../../../app/di/di.dart';
import '../../../../test/presentation/view_model/bloc/test_bloc.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: DashboardView(),
        ),
        BlocProvider(
          create: (context) => getIt<TestBloc>(),
          child: TestScreen(),
        ),
        BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: DashboardView(),
        ),
        const Center(
          child: Text('Account'),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
