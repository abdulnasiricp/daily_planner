// lib/main.dart

// ignore_for_file: avoid_print, deprecated_member_use

import 'package:daily_planner/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Define a global navigator key (useful for navigating from notifications)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permissions
  await _requestPermissions();

  runApp(const DailyPlannerApp());
}

Future<void> _requestPermissions() async {
  // Request notification permission for Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Request SCHEDULE_EXACT_ALARM permission
  if (await Permission.scheduleExactAlarm.isDenied) {
    final status = await Permission.scheduleExactAlarm.request();
    if (!status.isGranted) {
      print('SCHEDULE_EXACT_ALARM permission not granted.');
    }
  }

  // For iOS, permissions are handled by the plugin during initialization
}

class DailyPlannerApp extends StatelessWidget {
  const DailyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey, // Assign navigatorKey
        debugShowCheckedModeBanner: false,
        title: 'Daily Planner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
