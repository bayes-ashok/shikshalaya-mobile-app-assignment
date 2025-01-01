import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 248, 246, 246),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
