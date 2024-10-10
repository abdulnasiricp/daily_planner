// lib/widgets/task_item.dart

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/task_detail_screen.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final formattedTime = task.time.format(context);
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text('$formattedTime • ${task.category}'),
        trailing: Icon(
          Icons.flag,
          color: _getPriorityColor(task.priority),
        ),
        onTap: () {
          // Navigate to Task Detail Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: task.id),
            ),
          );
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
