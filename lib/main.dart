// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_const_constructors, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sam/QrCodeScanner.dart';

import 'package:sam/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "HomePage.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initDb();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
