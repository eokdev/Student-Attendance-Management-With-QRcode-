// ignore_for_file: unused_import, depend_on_referenced_packages, avoid_print, unrelated_type_equality_checks

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/tasks.dart';
import "tasks2.dart";
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'database2.dart';

class Toggle extends StateNotifier<List<Tasks2>> {
  Toggle() : super([]);
  List stater = [];
  add(Tasks2 tasks2) {
    stater = [
      ...state,
      tasks2,
      if (state.length == 1) {state.clear()}
    ];
  }

  delete(Tasks2 tasks2) {
    state.clear();
  }
  // List<Tasks2> stater = [];
  // Future<int> addTasks2(Tasks2 tasks) async {
  //   print("adding student in progress");
  //   return await DbHelper2.insert2(tasks);
  // }

  // getTasks2() async {
  //   List<Map<String, dynamic>> tasks2 = await DbHelper2.query2();
  //   print("getTasks method called");

  //   stater.assignAll(
  //     tasks2.map((data) => Tasks2.fromJson(data)).toList(),
  //   );
  //   print(tasks2);
  // }

  // void delete2(Tasks2 tasks) {
  //   DbHelper2.deleteTask2(tasks);
  //   getTasks2();
  // }

  // // void closeDb() {
  // //   DbHelper.close();
  // // }

  // void deleteDb2() {
  //   DbHelper2.delete2();
  //   getTasks2();
  // }
}
