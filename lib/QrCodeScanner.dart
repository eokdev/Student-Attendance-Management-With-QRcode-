// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unused_import, depend_on_referenced_packages, unused_element, unnecessary_import, avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, override_on_non_overriding_member, unnecessary_string_interpolations, unrelated_type_equality_checks, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sam/controller.dart';
import 'package:sam/provider.dart';
import 'package:sam/studentList.dart';
import 'package:sam/tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import 'package:state_notifier/state_notifier.dart';

String res = "";

class QrCodeScanner extends ConsumerStatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);
  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> {
  late List tasks = [
    if (tasks.length == 1) {tasks.clear()}
  ];

  late List imageData = [
    if (imageData.length == 1) {imageData.clear()}
  ];

  Future getWebDataImage(String link) async {
    final response = await http.get(Uri.parse("$link"));
    dom.Document html = dom.Document.html(response.body);

    final elements = html.getElementsByClassName("col-sm-12 col-md-4");
    tasks = elements
        .map((e) => e.getElementsByTagName("img")[0].attributes["src"])
        .toList();

    print("getWebDataImage Called");
    return tasks;
  }

  Future getWebDataText(String link) async {
    final response = await http.get(Uri.parse("$link"));
    dom.Document html = dom.Document.html(response.body);

    final elements = html.getElementsByClassName("col-10 mx-auto text-center");
    imageData =
        elements.map((e) => e.getElementsByTagName("h1")[0].innerHtml).toList();

    print("getWebDataText Called");
    return imageData;
  }

  QRViewController? controller;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    //controller!.resumeCamera();
    ref.read(myProvider.notifier).getTasks();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addTasks = ref.watch(myProvider.notifier);
    var queryHeight = MediaQuery.of(context).size.height;
    var queryWidth = MediaQuery.of(context).size.width;

    res = (result != null) ? result!.code.toString() : "";

    // In order to get hot reload to work we need to pause the camera if the platform
    // is android, or resume the camera if the platform is iOS.
    @override
    void reassemble() {
      super.reassemble();
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }

    void _onQrCodeCreated(QRViewController controller) {
      this.controller = controller;
      controller.scannedDataStream.listen((event) {
        setState(() {
          result = event;
        });
      });
    }

    getWebDataImage(res);
    getWebDataText(res);
    final changeColor = ref.watch(toggle.notifier).toggleMe;
    return Scaffold(
      //  backgroundColor: Color(0xff000000),
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: AppBar(
            centerTitle: true,
            title: Text("SAM(JABU)"),
            leading: Padding(
              padding: EdgeInsets.only(right: 5),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Image(
                    image: ExactAssetImage("images/appicons.png"),
                    height: 30,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    changeColor;
                    controller!.toggleFlash();
                  },
                  icon: Icon(
                    Icons.lightbulb_outline,
                    size: 30,
                    color: changeColor == false ? Colors.white : Colors.green,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => StList()));
                  },
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ))
            ],
          ),
        ),
      ),
      body: Container(
          height: queryHeight,
          width: queryWidth,
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                // overlay: QrScannerOverlayShape(
                //   borderColor: Colors.green,
                //   borderRadius: 30,
                // ),
                onQRViewCreated: _onQrCodeCreated,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Container(
              //     height: queryHeight*0.4,
              //     width: queryWidth * 0.9,
              //     decoration: BoxDecoration(
              //         border: Border.all(width: 1, color: Colors.green),
              //         borderRadius: BorderRadius.circular(30)
              //         ),
              //   ),
              // ),
              Align(
                alignment: Alignment.center,
                child: (result != null)
                    ? Text(
                        res.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    : Text(
                        "Tap on screen to resume camera ",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: () async {
                      await addTasks
                          .addTasks(Tasks(data: tasks[0], name: imageData[0]));
                      await ref.watch(myProvider.notifier).getTasks();

                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return StList();
                      }));
                    },
                    child: Text("+ Add Student")),
              )
            ],
          )),

      // ignore: deprecated_member_use
    );
  }
}
