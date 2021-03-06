import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/login.dart';
import 'package:ui_flutter/src/services/local_notification.dart';
import 'package:ui_flutter/src/services/services_carga.dart';
import 'package:ui_flutter/src/services/socket.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  String _versionName = 'V1.0';
  final splashDelay = 4;
  LocalNotification localNotification;

  @override
  void initState() {
    super.initState();
    _loadWidget();
    localNotification = new LocalNotification();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    if (App.localStorage.getString('token') != null) {
      // pone a escuchar todos los sokets
      ServicioSocket().iniciaSockets();
      // ---------------------------------------
      // carga todos los datos a la base de datos local
      ServicioCarga().cargarNuevosDatos();
      // ---------------------------------------

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => InicioPage()));
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
