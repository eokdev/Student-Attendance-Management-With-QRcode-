// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_overrides, unused_local_variable, avoid_print, annotate_overrides, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sam/database.dart';
import 'package:sam/tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class Notify extends StateNotifier<List<Tasks>> {
  Notify() : super([]);
  List<Tasks> stater = [];
  Future<int> addTasks(Tasks tasks) async {
    return await DbHelper.insert(tasks);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    print("getTasks method called");

    return stater.assignAll(
      tasks.map((data) => Tasks.fromJson(data)).toList(),
    );
  }
}

class Toggle extends StateNotifier {
  Toggle() : super(bool);
  final state = false;
 
}

final toggle = Provider<Toggle>((ref) {
  return Toggle();
});
// class TouchToggle extends ChangeNotifier {
//   bool stater = false;
//   toggleMe() {
//     stater = !stater;
//     notifyListeners();
//   }
// }

// final toggleProvider = Provider<TouchToggle>((ref) {
//   return TouchToggle();
// });
// class QrImage {
//  List tasks=[];
 
//  Future getWebData(String link) async {
//     final url = Uri.parse("$link");
//     final response = await http.get(url);
//     dom.Document html = dom.Document.html(response.body);

//     final elements = html.getElementsByClassName("col-sm-12 col-md-4");
//     tasks = elements
//         .map((e) => e.getElementsByTagName("img")[0].attributes["src"])
//         .toList();
//            print("getWebData Called");
// return tasks;
 
//   }
// }

// final provider = Provider<QrImage>((ref) {
//   return QrImage();
// });




// class TasksController extends GetxController {
//   @override
//   void onReady() {
//     super.onReady();
//   }

//   var tasksLists = <Tasks>[].obs;
  
//   Future<int> addTasks(Tasks tasks) async {
//     return await DbHelper.insert(tasks);
//   }

//   void getTasks() async {
//     print("getTasks method called");
//     List<Map<String, dynamic>> tasks = await DbHelper.query();

//     tasksLists.assignAll(
//       tasks.map((data) => Tasks.fromJson(data)).toList(),
//     );
//     print(tasks);
//   }
//   void pr(){
//     print(tasksLists.length);
//   }
// }
