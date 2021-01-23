import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/widgets/cont_sedes.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class pages_listas_sedes extends StatefulWidget {
  pages_listas_sedes({Key key}) : super(key: key);

  @override
  _pages_listas_sedesState createState() => _pages_listas_sedesState();
}

class _pages_listas_sedesState extends State<pages_listas_sedes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sedes'),
      ),
      body: Container(
        child: cont_sedes(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: WidgetsGenericos.floating_button_registrar(
          context, pageSedes('Registrar', null, null)),
    );
  }
}
