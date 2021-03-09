import 'dart:async';

import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/inicio.dart';

import 'package:ui_flutter/src/pages/login.dart';
import 'package:ui_flutter/src/services/local_notification.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/services/socket.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  String _versionName = 'V1.0';
  final splashDelay = 3;
  LocalNotification localNotification;

  @override
  void initState() {
    socketRes().conexion();
    super.initState();
    _loadWidget();
    localNotification = new LocalNotification();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      ServicioSede().cargarSedes(true);
      ServicioEmpresa().getEmpresa(true);
      SocketIO socket = await socketRes().conexion();
      socket.on('sedesres', (data) {
        if (data['tipo'] == "registro")
          localNotification.scheduleNotification(data['sede'], data['sede']);
        print('sedes cambio');
        ServicioSede().cargarSedes(true);
      });
      socket.on('empresasres', (_) {
        print('empresas cambio');
        ServicioEmpresa().getEmpresa(true);
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => InicioPage(1)));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => PageLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/icons/descarga32.png'),
                ),
                Spacer(),
                SpinKitWave(
                  color: Theme.of(context).accentColor,
                  size: 30.0,
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  _versionName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
