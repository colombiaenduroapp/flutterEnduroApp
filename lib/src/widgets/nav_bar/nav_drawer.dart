import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/inicio.dart';

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
              Text(text, style: TextStyle(fontSize: 20, color: Colors.black45)),
        )
      ],
    ),
    onTap: onTap,
  );
}

class Nav_drawerState extends State<Nav_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Juanito Perez',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
            ),
            accountEmail: Text('Juancho',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 18.0,
                )),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: NetworkImage(
                  'https://scontent-bog1-1.xx.fbcdn.net/v/t1.0-9/44431290_706071719755557_15078917211684864_n.jpg?_nc_cat=111&ccb=2&_nc_sid=09cbfe&_nc_ohc=PsdsvDqeBaAAX-L-e-J&_nc_ht=scontent-bog1-1.xx&oh=ea1b32144ca1560d810b34879700deb2&oe=5FD56025',
                ),
              ),
            ),
          ),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Inicio',
            onTap: () => Navigator.of(context).pushNamed('/'),
          ),
          Divider(),
          _createDrawerItem(icon: Icons.event_available, text: 'Eventos'),
          Divider(),
          _createDrawerItem(
              icon: Icons.apps,
              text: 'Sedes',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InicioPage(2)))),
          Divider(),
          _createDrawerItem(
              icon: Icons.emoji_transportation,
              text: 'Convenios',
              onTap: () => Navigator.pop(context)),
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
              onTap: () => Navigator.pop(context)),
          Divider(),
          _createDrawerItem(
              icon: Icons.contacts,
              text: 'Acerca de',
              onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
