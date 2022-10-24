
// ignore_for_file: unnecessary_this, prefer_collection_literals

class Tasks2 {
  int? id;
  String? controller1;
  String? controller2;
 
  Tasks2({this.id, this.controller1, this.controller2,});

  Tasks2.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    controller1 = json["controller1"];
    controller2 = json["controller2"];
 
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> input = Map<String, dynamic>();
    input["id"] = this.id;
    input["controller1"] = this.controller1;
    input["controller2"] = this.controller2;
    
    return input;
  }
}