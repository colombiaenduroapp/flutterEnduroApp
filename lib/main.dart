import 'dart:isolate';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/services/local_notification.dart';
import 'package:workmanager/workmanager.dart';

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

// ---------------------------------------------------
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    final int helloAlarmID = 0;
    ServicioSocket().conexion();
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(
        const Duration(minutes: 1), helloAlarmID, printHello,
        rescheduleOnReboot: true);
    print("Native called background task"); //simpleTask will be emitted here.
    ServicioSocket().iniciaSockets();

    return Future.value(true);
  });
}

void printHello() {
  LocalNotification localNotification = new LocalNotification();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;

  localNotification.scheduleNotification(
      'Se ha registrado una nueva sede ', 'hhjskjs');
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

// ------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();
  await Hive.initFlutter();
  await Hive.openBox('sedesdb');

  await Hive.openBox('publicacionesmasivasdb');
  await Hive.openBox('empresasdb');
  await Hive.openBox('bitacorasdb');
  await Hive.openBox('pqrsdb');
  runApp(MyApp());
  // ------------------------------------------
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager.registerPeriodicTask(
    "4",
    "simplePeriodicTask",
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );
  // -------------------------------------------
}
