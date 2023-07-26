import 'dart:async';

import 'package:gkrd/tools/Reminders/models/task_models.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

String path = "reminder.db";
int? version = 2;
String tableName = "tasks";
var logger = Logger();

class SQLHelper {
  //creating database table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tasks (
id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
title STRING, 
note STRING,
date STRING, 
startTime STRING, 

reminder STRING, 


isComplited INTEGER, 
createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)
""");
  }

  //create the database
  static Future<sql.Database> db() async {
    return sql.openDatabase("todo.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      logger.d("...creating the todo table......");
      await createTables(database);
    });
  }

  //insert task to the Databases
  static Future<int> createTask(ReminderTask task) async {
    logger.d("createTask Methods calls");
    final db = await SQLHelper.db();
    return await db.insert("tasks", task.toJson());
  }

  //get data from database
  static Future<List<Map<String, dynamic>>> getItems() async {
    logger.d("Queery Methods calls");
    final db = await SQLHelper.db();
    return db.query("tasks", orderBy: "id");
  }

//delete by id
  static deleteItem(ReminderTask task) async {
    logger.d("delete methods calls");
    final db = await SQLHelper.db();
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

//lets update items
  static Future<int> updateItems(ReminderTask task) async {
    final db = await SQLHelper.db();
    return db.update(
      'tasks',
      task.toJson(),
      where: "id = ?",
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //get data by id
  static Future<List<Map<String, dynamic>>> getItem(ReminderTask task) async {
    final db = await SQLHelper.db();
    return db.query("tasks", where: "id = ?", whereArgs: [task.id], limit: 1);
  }

  //update TaskCompletes

//   static updateCompleted(int id) async {
//     final db = await SQLHelper.db();
//     return db.rawUpdate('''
//   UPDATE tasks,
//   SET isComplited = ?
//   WHERE id = ?

// ''', [1, id]);
//   }

  static Future<int> updateCompleted(int id) async {
    final db = await SQLHelper.db();
    return db.rawUpdate('''
    UPDATE tasks
    SET isComplited = ?
    WHERE id = ?
  ''', [1, id]);
  }

  // static Future<int> updateItems(
  //     int id, String title, String description) async {
  //   final db = await SQLHelper.db();
  //   final data = {
  //     'title': title,
  //     'description': description,
  //     'createdAt': DateTime.now.toString()
  //   };

  //   final result = await db.update(
  //     'items',
  //     data,
  //     where: "id = ?",
  //     whereArgs: [id],
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return result;
  // }
}
