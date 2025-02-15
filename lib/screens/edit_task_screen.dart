// lib/screens/edit_task_screen.dart

// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _category;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _selectedDate = widget.task.date;
    _selectedTime = widget.task.time;
    _category = widget.task.category;
    _priority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Title
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!.trim();
                },
              ),
              const SizedBox(height: 10),
              // Description
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value!.trim();
                },
              ),
              const SizedBox(height: 10),
              // Date Picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat.yMd().format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              // Time Picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              const SizedBox(height: 10),
              // Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _category,
                items: ['Work', 'Personal', 'Health', 'Others']
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              // Priority Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Priority'),
                value: _priority,
                items: ['High', 'Medium', 'Low']
                    .map((pri) => DropdownMenuItem(
                          value: pri,
                          child: Text(pri),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Save Button
              ElevatedButton(
                child: const Text('Update Task'),
                onPressed: _updateTask,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pick a date
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Pick a time
  Future<void> _pickTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Update the task
  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedTask = Task(
        id: widget.task.id,
        title: _title,
        description: _description,
        date: _selectedDate,
        time: _selectedTime,
        category: _category,
        priority: _priority,
      );

      Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
      Navigator.pop(context);
    }
  }
}
