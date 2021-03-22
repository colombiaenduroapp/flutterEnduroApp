import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/listas_pqrs.dart';
import 'package:ui_flutter/src/pages/listas_sedes.dart';
import 'package:ui_flutter/src/pages/listas_empresas.dart';
import 'package:ui_flutter/src/pages/listas_bitacoras.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/login.dart';
import 'package:ui_flutter/src/pages/pqrs.dart';

import '../../../main.dart';

class Nav_drawer extends StatefulWidget {
  Nav_drawer({Key key}) : super(key: key);

  @override
  Nav_drawerState createState() => Nav_drawerState();
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
              Text(text, style: TextStyle(fontSize: 15, color: Colors.black54)),
        ),
      ],
    ),
    onTap: onTap,
  );
}

Widget _createDrawerItem1(
    {BuildContext context,
    IconData icon,
    String text,
    int cambio,
    String nombre_cambio,
    Widget onTap}) {
  return ListTile(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
              Text(text, style: TextStyle(fontSize: 15, color: Colors.black54)),
        ),
      ],
    ),
    trailing: cambio > 0
        ? Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child:
                Text(cambio.toString(), style: TextStyle(color: Colors.white)))
        : null,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => onTap),
      );
      App.localStorage.setInt('cambio_sede', 0);
    },
  );
}

class Nav_drawerState extends State<Nav_drawer> {
  String us_nombres = App.localStorage.getString('us_nombres') ?? '',
      us_alias = App.localStorage.getString('us_alias') ?? '';
  int cambio_sede = App.localStorage.getInt('cambio_sede') ?? 0;
  int cambio_empresa = App.localStorage.getInt('cambio_empresa') ?? 0;
  int cambio_bitacora = App.localStorage.getInt('cambio_bitacora') ?? 0;
  int cambio_pqrs = App.localStorage.getInt('cambio_pqrs') ?? 0;

  @override
  void initState() {
    setState(() {
      cambio_sede = cambio_sede;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // semanticLabel: ,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              us_nombres,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
            ),
            accountEmail: Text(us_alias,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 18.0,
                )),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: NetworkImage('https://picsum.photos/200/300'),
              ),
            ),
          ),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Inicio',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InicioPage(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem1(
            icon: Icons.event_available,
            text: 'Eventos',
            cambio: App.localStorage.getInt('cambio_evento') ?? 0,
            nombre_cambio: 'cambio_evento',
            onTap: InicioPage(),
          ),
          Divider(),
          _createDrawerItem1(
            context: context,
            icon: Icons.apps,
            text: 'Sedes',
            cambio: cambio_sede,
            nombre_cambio: 'cambio_sede',
            onTap: PageListasSedes(),
          ),
          Divider(),
          _createDrawerItem1(
            icon: Icons.apps,
            text: 'Bitacoras',
            cambio: cambio_bitacora,
            nombre_cambio: 'cambio_bitacora',
            onTap: pages_listas_bitacoras(),
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.emoji_transportation,
              text: 'Convenios',
              onTap: () => Navigator.pop(context)),
          Divider(),
          _createDrawerItem(
            icon: Icons.contacts,
            text: 'Empresas',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageListasEmpresas(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.search,
              text: 'Busqueda Emergencia',
              onTap: () => Navigator.pop(context)),
          Divider(),
          _createDrawerItem(
              icon: Icons.contacts,
              text: 'Boton Panico',
              onTap: () => Navigator.pop(context)),
          Divider(),
          _createDrawerItem1(
            icon: Icons.contacts,
            text: 'Quejas y Reclamos',
            cambio: cambio_pqrs,
            nombre_cambio: 'cambio_pqrs',
            onTap: PagesListasPqrs(),
          ),
          Divider(),
          _createDrawerItem(
              icon: Icons.contacts,
              text: 'Acerca de',
              onTap: () => Navigator.pop(context)),
          Divider(),
          _createDrawerItem(
            icon: Icons.contacts,
            text: 'Cerrar sesión',
            onTap: () async {
              SharedPreferences prefes = await SharedPreferences.getInstance();
              await prefes.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PageLogin()));
            },
          ),
        ],
      ),
    );
  }
}
