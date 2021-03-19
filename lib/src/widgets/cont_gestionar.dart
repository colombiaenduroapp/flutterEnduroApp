import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/listas_empresas.dart';
import 'package:ui_flutter/src/pages/listas_eventos.dart';
import 'package:ui_flutter/src/pages/listas_sedes.dart';

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
      child: InkWell(
        splashColor: Colors.amber,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                boxShadow: [
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
                    BotonGestionar().boton_gestionar(Icons.gamepad_outlined,
                        'Sedes', context, PagesListasSedes()),
                    BotonGestionar().boton_gestionar(
                        Icons.corporate_fare_outlined,
                        'Empresas',
                        context,
                        pages_listas_empresas()),
                    BotonGestionar().boton_gestionar(Icons.event, 'Eventos',
                        context, pages_listas_eventos()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BotonGestionar().boton_gestionar(
                        Icons.link,
                        'Publicacion Masivas',
                        context,
                        pages_listas_empresas()),
                    BotonGestionar().boton_gestionar(Icons.help_outline,
                        'Quejas', context, pages_listas_empresas()),
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'convenios',
                        context, pages_listas_empresas()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'Lideres',
                        context, pages_listas_empresas()),
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'Empresas',
                        context, pages_listas_empresas()),
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'Eventos',
                        context, pages_listas_empresas()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
