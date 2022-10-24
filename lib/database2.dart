// ignore_for_file: unused_import, prefer_const_declarations, depend_on_referenced_packages, avoid_print, prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables

import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "tasks2.dart";

class DbHelper2 {
  static Database? dbs;
  static final int versions = 1;
  static final String tableNames = "tasks2";
  static var paths;

  static Future<void> initDb() async {
    if (dbs != null) {
      return;
    }
    try {
      print("creating new one");

      paths = await getDatabasesPath() + "do.db";

      dbs = await openDatabase(paths, version: versions,
          onCreate: (db, version) async {
        print("creating new  for 2");
        await db.execute('''
CREATE TABLE $tableNames(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  controller1 STRING,
  controller2 STRING )
''');
      });
    } on DatabaseException catch (e) {
      print(e);
    }
  }

  static Future<int> insert2(Tasks2? tasks) async {
  //  print("insert method called for 2");
    return await dbs?.insert(tableNames, tasks!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query2() async {
    //print("query method called for 2");
    //print(dbs!.query(tableNames));
    return await dbs!.query(tableNames);
  }

  static deleteTask2(Tasks2 tasks) async {
    await dbs!.delete(tableNames, where: "id=?", whereArgs: [tasks.id]);
  }

  // static close() async {
  //   var dbClient = await db;
  //   return dbClient!.close();
  // }
  static delete2() async {
    await dbs!.delete(tableNames);
  }
}
