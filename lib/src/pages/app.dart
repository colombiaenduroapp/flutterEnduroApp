import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'inicio.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Colombia Enduro',
        theme: ThemeData(
          // Define el Brightness y Colores por defecto
          // brightness: Brightness.dark,
          // primarySwatch: Colors.orangeAccent[800],
          // accentColor: Colors.lightBlue[400],

          primaryColor: Colors.orange,
          secondaryHeaderColor: Colors.orange[100],
          accentColor: Colors.blueAccent,
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.purple)),

          // Define la Familia de fuente por defecto
          fontFamily: 'Montserrat',

          // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
          // para cabeceras, títulos, cuerpos de texto, y más.
        ),
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
