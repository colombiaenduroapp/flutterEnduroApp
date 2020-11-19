import 'package:flutter/material.dart';
import 'package:ui_flutter/src/nav_bar/tab_sede.dart';
import 'package:ui_flutter/src/pages/sedes.dart';

import 'inicio.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => InicioPage(),

      '/sedes': (context) => pageSedes(),

      // When navigating to the "/second"
    });
  }
}
