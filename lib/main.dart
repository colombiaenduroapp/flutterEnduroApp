import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/pages/app.dart';
import 'src/services/socket.dart';

class App {
  static SharedPreferences localStorage;
  static SocketIO conexion;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
    conexion = await ServicioSocket().conexion();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();
  await Hive.initFlutter();
  await Hive.openBox('sedesdb');
  await Hive.openBox('publicacionesmasivasdb');
  await Hive.openBox('empresasdb');
  await Hive.openBox('bitacorasdb');
  await Hive.openBox('pqrsdb');
  await Hive.openBox('solicitudusuariosdb');
  runApp(MyApp());
}
