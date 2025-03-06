import 'package:flutter/material.dart';
import 'package:shikshalaya/app/app.dart';
import 'package:shikshalaya/app/di/di.dart';
import 'package:shikshalaya/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await initDependencies();

  runApp(
    App(),
  );
}
