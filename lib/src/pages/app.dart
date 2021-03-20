import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ui_flutter/src/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      title: 'Colombia Enduro',

      theme: ThemeData(
        brightness: Brightness.light,
        // scaffoldBackgroundColor: Colors.white70,
        primaryColor: Colors.blueGrey[800],
        primaryColorLight: Colors.blueGrey[500],
        dialogBackgroundColor: Colors.blueGrey[200],
        textSelectionColor: Colors.black,
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        cardColor: Colors.blueGrey[50],
        secondaryHeaderColor: Colors.orange[100],
        accentColor: Colors.orange[400],
        backgroundColor: Colors.white,
        highlightColor: Colors.grey[300],

        // Define la Familia de fuente por defecto
        fontFamily: 'Montserrat',

        // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
        // para cabeceras, títulos, cuerpos de texto, y más.
      ),
      darkTheme: ThemeData(
        //Se indica que el tema tiene un brillo oscuro
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Colors.grey[900],
        primaryColorLight: Colors.grey[700],
        dialogBackgroundColor: Colors.grey[600],
        cardColor: Colors.black12,
        splashColor: Colors.blueGrey[200],
        textSelectionColor: Colors.white,
        secondaryHeaderColor: Colors.orange[100],
        accentColor: Colors.orange[400],
      ),

      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('es')],
      // initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
