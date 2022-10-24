// ignore_for_file: unused_import, prefer_collection_literals, unused_local_variable, unnecessary_this

import 'package:flutter/material.dart';

class Tasks {
  int? id;
  String? data;
  String? name;
 
  Tasks({this.id, this.data, this.name,});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    data = json["data"];
    name = json["name"];
 
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> input = Map<String, dynamic>();
    input["id"] = this.id;
    input["data"] = this.data;
    input["name"] = this.name;
    
    return input;
  }
}
