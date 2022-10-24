// ignore_for_file: unused_import, file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, depend_on_referenced_packages, unused_local_variable, library_private_types_in_public_api, unnecessary_import, use_build_context_synchronously, avoid_print

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:sam/QrCodeScanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/provider.dart';
import 'package:sam/tasks.dart';

import 'tasks2.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final input = ref.watch(myProvider2.notifier);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    "images/Jabu.png",
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Register Your Course",
                  style:
                      GoogleFonts.pacifico(color: Colors.black, fontSize: 21),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: TextField(
                    controller: textEditingController1,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.perm_contact_cal),
                        border: InputBorder.none,
                        hintText: "Lecturer Name...",
                        hintStyle: GoogleFonts.lato(fontSize: 15)),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: textEditingController2,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.class_),
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.lato(fontSize: 15),
                        hintText: "Input Course Code"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.4, 35)),
                  onPressed: () {
                    input.add(Tasks2(
                        controller1: textEditingController1.text,
                        controller2: textEditingController2.text));
                    if (textEditingController1.text.isNotEmpty &&
                        textEditingController2.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => QrCodeScanner()),
                      );
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Resgister Your Course"))
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.track_changes),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Submit to Scan",
                        style: GoogleFonts.lato(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
