// ignore_for_file: unused_import, file_names, prefer_const_constructors, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sam/controller.dart';

class StList extends StatefulWidget {
  const StList({Key? key}) : super(key: key);

  @override
  State<StList> createState() => _StListState();
}

class _StListState extends State<StList> {
  final tasksController = Get.put(TasksController());
    @override
      void initState() {
    super.initState();
    tasksController.getTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SAM"),
      ),
      body: Column(
        children: [
          Expanded(child: Obx(() {
            return ListView.builder(
                itemCount: tasksController.tasksLists.length,
                itemBuilder: (BuildContext context, int index) {
                  print(tasksController.tasksLists.length);
                  return ListTile(
                    title:
                        Text(tasksController.tasksLists[index].data.toString()),
                  );
                });
          })),
        ],
      ),
    );
  }
}
