import 'package:flutter/material.dart';
import 'package:shikshalaya/app.dart';
import 'package:shikshalaya/service%20locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MyApp(),
  );
}
