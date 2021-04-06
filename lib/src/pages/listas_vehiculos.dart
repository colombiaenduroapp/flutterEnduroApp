import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/vehiculos.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PageListasVehiculos extends StatefulWidget {
  PageListasVehiculos({Key key}) : super(key: key);

  @override
  _PageListasVehiculosState createState() => _PageListasVehiculosState();
}

class _PageListasVehiculosState extends State<PageListasVehiculos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Vehiculos'),
      ),
      body: Center(
        child: Container(
          child: Text('Hola mundo'),
        ),
      ),
      // drawer: Nav_drawer(),
      floatingActionButton:
          WidgetsGenericos.floatingButtonRegistrar(context, PageVehiculos()),
    );
  }
}
