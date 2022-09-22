// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, sized_box_for_whitespace, unused_import, depend_on_referenced_packages, unused_element, unnecessary_import, avoid_print

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sam/controller.dart';
import 'package:sam/studentList.dart';
import 'package:sam/tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);
  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  QRViewController? controller;
  Barcode? result;
  final GlobalKey qrKey = GlobalKey();
  final tasksController = Get.put(TasksController());
  @override
  void initState() {
    super.initState();
    tasksController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    var queryHeight = MediaQuery.of(context).size.height;
    var queryWidth = MediaQuery.of(context).size.width;
    String newResult = (result != null) ? result!.code.toString() : "";

    addTasks() async {
      TasksController taskcontroller = Get.put(TasksController());
      var value = await taskcontroller.addTasks(
        Tasks(data: newResult.toString()),
      );
      print("id is$value");
    }

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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SAM"),
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
              child: (result != null)
                  ? Text(newResult.toString())
                  : Text("Scan Code"),
            ),
            // child: ListView.builder(
            //   itemCount: 1,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Center(
            //         child: (result != null)
            //             ? Text(result!.code.toString())
            //             : Text("Scan Code"));
            //   },
            //   // children:
            //   //   code.map((e) => (result != null)
            //   //         ? Text(
            //   //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
            //   //         : Text('Scan a code'),
            //   //    ,)
            // ),
          ),
          // ignore: deprecated_member_use
          ElevatedButton(
              onPressed: () {
                addTasks();
                tasksController.getTasks();
                tasksController.pr();
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => StList()));
              },
              child: Text("+ Add Student"))
        ],
      ),
    );
  }
}
