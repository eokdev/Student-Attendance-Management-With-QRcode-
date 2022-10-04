// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unused_import, depend_on_referenced_packages, unused_element, unnecessary_import, avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, override_on_non_overriding_member, unnecessary_string_interpolations, unrelated_type_equality_checks

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

bool? text;
bool? image;

class QrCodeScanner extends ConsumerStatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);
  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> {
  String? res;
  late List tasks = [
      if (tasks.length == 1) {tasks.clear()}
  ];

  late List imageData = [
     if (imageData.length == 1) {imageData.clear()}
  ];

  Future getWebDataImage(String link) async {
    text = false;
    final url = Uri.parse("$link");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final elements = html.getElementsByClassName("col-sm-12 col-md-4");
    tasks = elements
        .map((e) => e.getElementsByTagName("img")[0].attributes["src"])
        .toList();
    text = true;
    print("getWebDataImage Called");
    return tasks;
  }

  Future getWebDataText(String link) async {
    image = false;
    final url = Uri.parse("$link");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final elements = html.getElementsByClassName("col-10 mx-auto text-center");
    imageData =
        elements.map((e) => e.getElementsByTagName("h1")[0].innerHtml).toList();
    image = true;
    print("getWebDataText Called");
    return imageData;
  }

  @override
  void initState() {
    super.initState();

    ref.read(myProvider.notifier).getTasks();
  }

  QRViewController? controller;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey();

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

// final newprovider = Provider<String>((ref) {
//   return newResult;
// });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SAM"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => StList()));
              },
              icon: Icon(Icons.arrow_back))
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
                height: queryHeight * 0.5,
                width: queryWidth * 0.8,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQrCodeCreated,
                )),
          ),
          Expanded(
            child: Center(
              child:
                  (result != null) ? Text(res.toString()) : Text("Scan Code"),
            ),
          ),

          // ignore: deprecated_member_use
          Consumer(builder: (context, watch, child) {
            final addTasks = ref.watch(myProvider.notifier);
            getWebDataImage(res.toString());
            getWebDataText(res.toString());
            return ElevatedButton(
                onPressed: () {
                  addTasks.addTasks(Tasks(data: tasks[0], name: imageData[0]));
                  ref.watch(myProvider.notifier).getTasks();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => StList()));
                },
                child: Text("+ Add Student"));
          })
        ],
      ),
    );
  }
}
