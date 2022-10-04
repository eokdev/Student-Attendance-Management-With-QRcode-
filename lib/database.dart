// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_const_declarations, prefer_typing_uninitialized_variables, avoid_print, prefer_interpolation_to_compose_strings

import 'package:get/get.dart';
import 'package:sam/tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DbHelper {
  static Database? db;
  static final int version = 1;
  static final String tableName = "tasks";
  static var path;

  static Future<void> initDb() async {
    if (db != null) {
      return;
    }
    try {
      print("creating new one");

      path = await getDatabasesPath() + "demo.db";
      await deleteDatabase(path);
      db = await openDatabase(path, version: version,
          onCreate: (db, version) async {
        print("creating new one");
        await db.execute("""
CREATE TABLE $tableName(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  data STRING,
  name STRING )
""");
      });
    } on DatabaseException catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Tasks? tasks) async {
    print("insert method called");
    return await db?.insert(tableName, tasks!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query method called");
    return await db!.query(tableName);
  }
}
