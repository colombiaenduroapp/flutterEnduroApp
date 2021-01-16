import 'package:flutter/material.dart';

import 'boton_gestionar.dart';

class cont_gestionar extends StatefulWidget {
  cont_gestionar({Key key}) : super(key: key);

  @override
  _cont_gestionarState createState() => _cont_gestionarState();
}

class _cont_gestionarState extends State<cont_gestionar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.blueGrey[50], boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BotonGestionar().boton_gestionar(Icons.gamepad, 'Sedes'),
                BotonGestionar()
                    .boton_gestionar(Icons.corporate_fare, 'Empresas'),
                BotonGestionar().boton_gestionar(Icons.event, 'Eventos'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BotonGestionar()
                    .boton_gestionar(Icons.link, 'Publicacion Masivas'),
                BotonGestionar().boton_gestionar(Icons.help, 'Quejas'),
                BotonGestionar().boton_gestionar(Icons.gamepad, 'convenios'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BotonGestionar().boton_gestionar(Icons.gamepad, 'Lideres'),
                BotonGestionar().boton_gestionar(Icons.gamepad, 'Empresas'),
                BotonGestionar().boton_gestionar(Icons.gamepad, 'Eventos'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
