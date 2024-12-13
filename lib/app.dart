import 'package:flutter/material.dart';
import 'package:shikshalaya/view/onboarding_screen.dart';
// import 'package:shikshalaya/view/home_page.dart';
// import 'package:shikshalaya/view/register_view.dart';
// import 'package:shikshalaya/view/login_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const OnboardingScreen(),
      },
    );
  }
}
