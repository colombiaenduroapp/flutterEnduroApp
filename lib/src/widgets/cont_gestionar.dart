import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/listas_empresas.dart';
import 'package:ui_flutter/src/pages/listas_eventos.dart';
import 'package:ui_flutter/src/pages/listas_pqrs.dart';
import 'package:ui_flutter/src/pages/listas_sedes.dart';

import 'boton_gestionar.dart';

class ContGestionar extends StatefulWidget {
  ContGestionar({Key key}) : super(key: key);

  @override
  _ContGestionarState createState() => _ContGestionarState();
}

class _ContGestionarState extends State<ContGestionar> {
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
                        'Sedes', context, PageListasSedes()),
                    BotonGestionar().boton_gestionar(
                        Icons.corporate_fare_outlined,
                        'Empresas',
                        context,
                        PageListasEmpresas()),
                    BotonGestionar().boton_gestionar(
                        Icons.event, 'Eventos', context, PageListasEventos()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BotonGestionar().boton_gestionar(Icons.link,
                        'Publicacion Masivas', context, PageListasEmpresas()),
                    BotonGestionar().boton_gestionar(Icons.help_outline,
                        'Quejas', context, PagesListasPqrs()),
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'convenios',
                        context, PageListasEmpresas()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'Lideres',
                        context, PageListasEmpresas()),
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'Empresas',
                        context, PageListasEmpresas()),
                    BotonGestionar().boton_gestionar(Icons.gamepad, 'Eventos',
                        context, PageListasEmpresas()),
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
