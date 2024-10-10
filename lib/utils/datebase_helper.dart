// lib/utils/database_helper.dart

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('daily_planner.db');
    return _database!;
  }

  // Create the database and tasks table
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the tasks table
  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE tasks (
        id $idType,
        title $textType,
        description $textType,
        date $dateType,
        time $textType,
        category $textType,
        priority $textType
      )
    ''');
  }

  // Insert a new task
  Future<void> insertTask(Map<String, dynamic> row) async {
    final db = await instance.database;
    await db.insert(
      'tasks',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await instance.database;
    return await db.query('tasks');
  }

  // Update an existing task
  Future<int> updateTask(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      row,
      where: 'id = ?',
      whereArgs: [row['id']],
    );
  }

  // Delete a task
  Future<int> deleteTask(String id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
