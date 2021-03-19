import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/listas_sedes.dart';
import 'package:ui_flutter/src/pages/listas_empresas.dart';
import 'package:ui_flutter/src/pages/listas_bitacoras.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/login.dart';
import 'package:ui_flutter/src/pages/pqrs.dart';

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
        )
      ],
    ),
    onTap: onTap,
  );
}

class Nav_drawerState extends State<Nav_drawer> {
  String us_nombres = '', us_alias = '';
  int us_perfil = 1;
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // us_cdgo = prefs.getInt('us_cdgo') ?? 0;
    setState(() {
      us_nombres = prefs.getString('us_nombres') ?? '';
      us_alias = prefs.getString('us_alias') ?? '';
      us_perfil = prefs.getInt('us_perfil') ?? '';
    });
  }

  @override
  void initState() {
    addStringToSF();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                builder: (context) => InicioPage(us_perfil),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.event_available,
            text: 'Eventos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InicioPage(us_perfil),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.apps,
            text: 'Sedes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PagesListasSedes(),
              ),
            ),
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.apps,
            text: 'Bitacoras',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pages_listas_bitacoras(),
              ),
            ),
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
                builder: (context) => pages_listas_empresas(),
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
          _createDrawerItem(
            icon: Icons.contacts,
            text: 'Quejas y Reclamos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PagesPQRS(),
              ),
            ),
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
