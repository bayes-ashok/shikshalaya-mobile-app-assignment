import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikshalaya/common/bottom_nav.dart';
import 'package:shikshalaya/cubit/dashboard_cubit.dart';
import 'package:shikshalaya/service%20locator/service_locator.dart';
import 'package:shikshalaya/theme/theme_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
      home: BlocProvider.value(
        value: serviceLocator<DashboardCubit>(),
        child: BottomNav(),
      ),
    );
  }
}
