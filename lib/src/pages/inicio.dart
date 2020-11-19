import 'package:flutter/material.dart';

import 'package:ui_flutter/src/widgets/tab_bar/tab_evento.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_inicio.dart';
import 'package:ui_flutter/src/widgets/tab_bar/tab_sede.dart';

import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';

class InicioPage extends StatefulWidget {
  InicioPage({Key key}) : super(key: key);

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'COLOMBIA ENDURO',
            ),
            bottom: TabBar(indicatorColor: Colors.red, tabs: [
              new Tab(icon: new Icon(Icons.home), text: "Inicio"),
              new Tab(icon: new Icon(Icons.event), text: "Eventos"),
              new Tab(icon: new Icon(Icons.event), text: "Sedes"),
            ]),
          ),
          body: TabBarView(
            children: [tab_inicio(), tab_evento(), tab_sede()],
          ),
          drawer: Nav_drawer(),
        ));
  }
}

Widget title = Container(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
          child: Column(
        children: [
          Container(
            child: Text('Hola Mundo'),
          ),
          Text(
            'hola mundo gris',
            style: TextStyle(color: Colors.blueGrey[100]),
          )
        ],
      )),
      Icon(
        Icons.star,
        color: Colors.red,
      ),
      Text('42')
    ],
  ),
);
