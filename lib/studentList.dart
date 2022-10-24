// ignore_for_file: unused_import, file_names, prefer_const_constructors, depend_on_referenced_packages, avoid_print, library_private_types_in_public_api, unused_local_variable, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, unnecessary_this, unnecessary_null_comparison, unnecessary_string_interpolations, sized_box_for_whitespace, deprecated_member_use, prefer_collection_literals, body_might_complete_normally_nullable, prefer_is_empty, prefer_const_literals_to_create_immutables, list_remove_unrelated_type, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sam/QrCodeScanner.dart';
import 'package:sam/controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:sam/tasks.dart';

class StList extends ConsumerStatefulWidget {
  StList({Key? key}) : super(key: key);

  @override
  _StListState createState() => _StListState();
}

class _StListState extends ConsumerState<StList> {
  @override
  void initState() {
    super.initState();
    ref.read(myProvider.notifier).getTasks();
    //ref.read(myProvider2.notifier).getTasks2();
  }

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(myProvider.notifier).stater;
// final userImage = ref.watch(myProvider.notifier).imageData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(tag: "shift", child: Icon(Icons.arrow_back, size: 30)),
        ),
        centerTitle: true,
        title: userList.length <= 1
            ? Text(
                "List Of Attendee",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 25),
              )
            : Text(
                "List Of Attendees",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 25),
              ),
      ),
      body: userList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.do_not_disturb_alt_outlined,
                    color: Colors.grey,
                    size: 100,
                  ),
                  Text(
                    "No Student",
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Consumer(builder: (context, ref, child) {
                  final list = ref.read(myProvider2.notifier).stater;
                  return Text(list[0].controller1.toString(), style:   GoogleFonts.lato(color: Colors.black, fontSize: 20),);
                }),
                Consumer(builder: (context, ref, child) {
                  final list = ref.read(myProvider2.notifier).stater;
                  return Text(list[0].controller2.toString(), style: GoogleFonts.lato(color: Colors.black, fontSize: 20),);
                }),
                // ref.read(myProvider2.notifier).stater2.isEmpty
                //     ? Text("nothing")
                //     : Text(
                //         "${ref.read(myProvider2.notifier).stater2[0].controller1}"),
                // ref.read(myProvider2.notifier).stater2.isEmpty
                //     ? Text("nothing")
                //     : Text(
                //         "${ref.read(myProvider2.notifier).stater2[0].controller2}"),

                Expanded(
                  child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(userList.length);
                        print(userList);
                        print(userList[index]);
                        return Column(
                          children: [
                            Slidable(
                              key: ValueKey(0),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      //delete for each with its index
                                      
                                      ref
                                          .read(myProvider.notifier)
                                          .delete(userList[index]);
                                      ref
                                          .read(myProvider.notifier)
                                          .stater
                                          .remove(userList[index]);
                                      ref.read(myProvider.notifier).getTasks();
                                      setState(() {
                                        
                                      });
                                    },
                                    icon: Icons.delete,
                                    label: "Delete",
                                    backgroundColor: Colors.red,
                                  ),
                                ],
                              ),
                              child: Card(
                                child: ListTile(

                                  leading: Text("${index+1}" ),
                                  trailing: CircleAvatar(
                                    child: Image.network(
                                      userList[index].data.toString(),
                                      width: 100,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(userList[index].name.toString()),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: (context),
              builder: (context) {
                return AlertDialog(
                  title: Icon(
                    Icons.delete_forever,
                    size: 50,
                  ),
                  content: Text(
                    "Are you sure you want to permanently delete all the List of Attendes?",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                  actions: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red)),
                        onPressed: () {
                          ref.watch(myProvider.notifier).deleteDb();
                          ref.watch(myProvider.notifier).stater.clear();
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                );
              });
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
