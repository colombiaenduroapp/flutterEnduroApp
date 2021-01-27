import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
          context, pageSedes('Registrar', null, null)),
    );
  }
}
