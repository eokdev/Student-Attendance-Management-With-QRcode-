// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unused_import, depend_on_referenced_packages, unused_element, unnecessary_import, avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, override_on_non_overriding_member, unnecessary_string_interpolations, unrelated_type_equality_checks, use_build_context_synchronously, avoid_unnecessary_containers, invalid_use_of_protected_member, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sam/HomePage.dart';
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
import 'package:motion_toast/motion_toast.dart';

String res = "";

class QrCodeScanner extends ConsumerStatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);
  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> {
  bool checme = false;
  Key keyy = UniqueKey();
  void restartApp() {
    setState(() {
      keyy = UniqueKey();
    });
  }

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
    imageData = elements
        .map((e) => e.getElementsByTagName("img")[0].attributes["src"])
        .toList();

    print("getWebDataImage Called");
    return imageData;
  }

  Future getWebDataText(String link) async {
    final response = await http.get(Uri.parse("$link"));
    dom.Document html = dom.Document.html(response.body);

    final elements = html.getElementsByClassName("col-10 mx-auto text-center");
    tasks =
        elements.map((e) => e.getElementsByTagName("h1")[0].innerHtml).toList();

    print("getWebDataText Called");
    return tasks;
  }

  QRViewController? controller;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    ref.read(myProvider.notifier).getTasks();
    //ref.read(myProvider2.notifier).getTasks2();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
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

    if (res.startsWith("ht")) {
      //snackbar

    }
  getWebDataImage(res);
    getWebDataText(res);
    bool? me;

    return Scaffold(
      //  backgroundColor: Color(0xff000000),
      appBar: PreferredSize(
        preferredSize: Size(0, 80),
        child: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 80,
          elevation: 5,
          centerTitle: true,
          shadowColor: Color.fromRGBO(158, 158, 158, 1),
          title: Text(
            "SAM(JABU)",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueGrey,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Image(
                  fit: BoxFit.contain,
                  image: ExactAssetImage("images/appicons.png"),
                  height: 25,
                ),
              ),
            ),
          ),
          actions: [
            Consumer(builder: (contextt, watch, child) {
              return GestureDetector(
                onTap: () {
                  checme = !checme;
                  if (checme == true) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Torchlight On"),
                      duration: Duration(seconds: 1),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Torchlight Off"),
                      duration: Duration(seconds: 1),
                    ));
                  }
                  controller!.toggleFlash();

                  setState(() {});

                  print(checme);
                },
                child: Hero(
                  tag: "shift",
                  child: Icon(
                    Icons.lightbulb_outline,
                    size: 37,
                    color: checme == false ? Colors.white : Colors.yellow,
                  ),
                ),
              );
            }),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  //ref.read(myProvider.notifier).getTasks();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => StList()),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward,
                  size: 30,
                ))
          ],
        ),
      ),
      body: Container(
          height: queryHeight,
          width: queryWidth,
          child: Stack(
            children: [
              InkWell(
                onLongPress: () {
                  controller!.resumeCamera();
                },
                child: QRView(
                  cameraFacing: CameraFacing.back,
                  key: qrKey,
                  // overlay: QrScannerOverlayShape(
                  //   borderColor: Colors.blue,
                  //   borderRadius: 30,
                  // ),
                  onQRViewCreated: _onQrCodeCreated,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: (result != null)
                    ? Text(
                        res.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    : Text(
                        "LongPress on screen to resume camera ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Consumer(builder: (context, ref, child) {
                  final addTasks = ref.watch(myProvider.notifier);
                  return ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      onPressed: res.isEmpty
                          ? () {
                              //import snackbar here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "              WARNING!\n\n - Tap on screen to resume camera\n - Scan the student QrCode\n - Connect to Internet\n - Click on + Add Student button",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );  
                              print("dont call mee");
                            }
                          : () async{
                          await    addTasks.addTasks(
                                  Tasks(name: tasks[0], data: imageData[0]));
                           await        ref.read(myProvider.notifier).getTasks();
                              // await name.addImage(
                              //     ref.read(myProvider.notifier).imageData[0]);
                         await   Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return StList();
                              }));
                            },
                      child: Text("+ Add Student"));
                }),
              ),
            ],
          )),

      // ignore: deprecated_member_use
    );
  }
}
