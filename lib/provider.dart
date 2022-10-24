// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_import, avoid_print, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/controller.dart';
import 'package:sam/tasks.dart';
import 'QrCodeScanner.dart';
import 'controller2.dart';
import 'tasks2.dart';

final myProvider = StateNotifierProvider<Notify, List<Tasks>>(
  (ref) => Notify(),
);
final myProvider2 = StateNotifierProvider<Toggle, List<Tasks2>>(
  (ref) => Toggle(),
);

// final qrImage = FutureProvider((ref) {
//   return ref.watch(provider).getWebData(res.toString());
// });
