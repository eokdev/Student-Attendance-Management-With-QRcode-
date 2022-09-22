// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_overrides, unused_local_variable, avoid_print

import 'package:get/get.dart';
import 'package:sam/database.dart';
import 'package:sam/tasks.dart';

class TasksController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var tasksLists = <Tasks>[].obs;
  
  Future<int> addTasks(Tasks tasks) async {
    return await DbHelper.insert(tasks);
  }

  void getTasks() async {
    print("getTasks method called");
    List<Map<String, dynamic>> tasks = await DbHelper.query();

    tasksLists.assignAll(
      tasks.map((data) => Tasks.fromJson(data)).toList(),
    );
    print(tasks);
  }
  void pr(){
    print(tasksLists.length);
  }
}
