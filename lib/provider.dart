// ignore_for_file: unused_import, depend_on_referenced_packages, unnecessary_import, avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sam/controller.dart';
import 'package:sam/tasks.dart';
import 'QrCodeScanner.dart';

final myProvider = StateNotifierProvider<Notify, List<Tasks>>(
  (ref) => Notify(),
);

// final qrImage = FutureProvider((ref) {
//   return ref.watch(provider).getWebData(res.toString());
// });
