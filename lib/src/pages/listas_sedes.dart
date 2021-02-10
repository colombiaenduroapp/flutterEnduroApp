import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/widgets/cont_sedes.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesListasSedes extends StatefulWidget {
  PagesListasSedes({Key key}) : super(key: key);

  @override
  _PagesListasSedesState createState() => _PagesListasSedesState();
}

class _PagesListasSedesState extends State<PagesListasSedes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sedes'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InicioPage(0),
                  ),
                )),
      ),
      body: Container(
        child: cont_sedes(),
      ),
      floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
          context, pageSedes('Registrar', null, null)),
    );
  }
}
