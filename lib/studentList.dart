// ignore_for_file: unused_import, file_names, prefer_const_constructors, depend_on_referenced_packages, avoid_print, library_private_types_in_public_api, unused_local_variable, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, unnecessary_this, unnecessary_null_comparison, unnecessary_string_interpolations, sized_box_for_whitespace, deprecated_member_use, prefer_collection_literals, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sam/QrCodeScanner.dart';
import 'package:sam/controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class StList extends ConsumerStatefulWidget {
  
  @override
  _StListState createState() => _StListState();
}

class _StListState extends ConsumerState<StList> {
  @override
  void initState() {
    super.initState();
    
    // ref.read(qrImage);
    ref.read(myProvider.notifier).getTasks();
  }

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(myProvider);
// final image = ref.watch(qrImage);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SAM"),
      ),
      body: Column(
        children: [
          Expanded(child: Consumer(builder: (context, watch, child) {
            return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: image == false
                        ? CircularProgressIndicator()
                        : CircleAvatar(
                            child: Image.network(
                              userList[index].data.toString(),
                              width: 100,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                    title: text == false
                        ? Text("Loading....")
                        : Text(userList[index].name.toString()),
                  );
                });
          })),
        ],
      ),
    );
  }
}
