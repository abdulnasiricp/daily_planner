// ignore_for_file: avoid_print

import 'package:daily_planner/utils/datebase_helper.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  TaskProvider() {
    fetchTasks();
    // Timezone already initialized in main.dart
  }

  List<Task> get tasks => _tasks;

  // Fetch tasks from the database
  Future<void> fetchTasks() async {
    final dataList = await DatabaseHelper.instance.getTasks();
    _tasks = dataList.map((item) => Task.fromMap(item)).toList();
    notifyListeners();
  }

  // Get tasks by specific date
  List<Task> getTasksByDate(DateTime date) {
    return _tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();
  }

  // Add a new task
  Future<void> addTask(Task task) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: task.title,
      description: task.description,
      date: task.date,
      time: task.time,
      category: task.category,
      priority: task.priority,
    );
    await DatabaseHelper.instance.insertTask(newTask.toMap());
    _tasks.add(newTask);
    notifyListeners();

    // Check permission before scheduling notification
    if (await _hasScheduleExactAlarmPermission()) {
      // Schedule notification
    } else {
      print(
          'Exact alarm permission not granted. Notification not scheduled for task: ${newTask.title}');
    }
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      await DatabaseHelper.instance.updateTask(task.toMap());
      _tasks[index] = task;
      notifyListeners();

      // Check permission before scheduling notification
      if (await _hasScheduleExactAlarmPermission()) {
        // Reschedule notification
      } else {
        print(
            'Exact alarm permission not granted. Notification not rescheduled for task: ${task.title}');
      }
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // Check if the app has SCHEDULE_EXACT_ALARM permission
  Future<bool> _hasScheduleExactAlarmPermission() async {
    // Check if the notification permission is granted
    if (await Permission.notification.isGranted) {
      // For Android 13+, check if SCHEDULE_EXACT_ALARM is granted
      if (await Permission.scheduleExactAlarm.isGranted) {
        return true;
      } else {
        // Open app settings to allow the user to grant SCHEDULE_EXACT_ALARM
        bool opened = await openAppSettings();
        if (opened) {
          print('Opened app settings for SCHEDULE_EXACT_ALARM permission.');
        } else {
          print('Could not open app settings.');
        }
        return false;
      }
    }
    return false;
  }
}
