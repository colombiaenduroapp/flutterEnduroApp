import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'inicio.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Colombia Enduro',
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('es')],
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => InicioPage(0),

          // When navigating to the "/second"
        });
  }
}
