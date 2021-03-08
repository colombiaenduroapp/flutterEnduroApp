import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/pages/app.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('sedesdb');
  await Hive.openBox('empresasdb');
  runApp(MyApp());
}
