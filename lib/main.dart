import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/pages/app.dart';

class App {
  static SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();
  await Hive.initFlutter();
  await Hive.openBox('sedesdb');
  await Hive.openBox('empresasdb');
  await Hive.openBox('bitacorasdb');
  runApp(MyApp());
}
