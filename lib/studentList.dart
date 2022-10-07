// ignore_for_file: unused_import, file_names, prefer_const_constructors, depend_on_referenced_packages, avoid_print, library_private_types_in_public_api, unused_local_variable, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, unnecessary_this, unnecessary_null_comparison, unnecessary_string_interpolations, sized_box_for_whitespace, deprecated_member_use, prefer_collection_literals, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sam/QrCodeScanner.dart';
import 'package:sam/controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class StList extends ConsumerWidget {
  StList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userList = ref.read(myProvider.notifier).stater;
   
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("List Of Attendees"),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  
                  return ListTile(
                    leading: CircleAvatar(
                      child: Image.network(
                        userList[index].data.toString(),
                        width: 100,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(userList[index].name.toString()),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
