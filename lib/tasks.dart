// ignore_for_file: unused_import, prefer_collection_literals, unused_local_variable, unnecessary_this

import 'package:flutter/material.dart';

class Tasks {
  int? id;
  String? data;

  Tasks({this.id, this.data});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    data = json["data"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> input = Map<String, dynamic>();
    input["id"] = this.id;
    input["data"] = this.data;
    return input;
  }
}
