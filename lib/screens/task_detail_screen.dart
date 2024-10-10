// lib/screens/task_detail_screen.dart

// ignore_for_file: unnecessary_null_comparison

import 'package:daily_planner/screens/edit_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final Task task = taskProvider.tasks.firstWhere(
      (t) => t.id == taskId,
    );

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
        ),
        body: const Center(
          child: Text('Task not found.'),
        ),
      );
    }

    final formattedDate = DateFormat.yMMMd().format(task.date);
    final formattedTime = task.time.format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to Edit Task Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Delete the task with confirmation
              _confirmDelete(context, taskProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              task.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Date and Time
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Text(formattedDate),
                const SizedBox(width: 20),
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(formattedTime),
              ],
            ),
            const SizedBox(height: 20),
            // Category and Priority
            Row(
              children: [
                Chip(
                  label: Text(task.category),
                ),
                const SizedBox(width: 10),
                Chip(
                  label: Text(task.priority),
                  backgroundColor: _getPriorityColor(task.priority),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _confirmDelete(BuildContext context, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              provider.deleteTask(taskId);
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to home
            },
          ),
        ],
      ),
    );
  }
}
