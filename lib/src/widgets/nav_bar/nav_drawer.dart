import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/pages/listas_publicacion_masiva.dart';
import 'package:ui_flutter/src/pages/listas_sedes.dart';
import 'package:ui_flutter/src/pages/listas_empresas.dart';
import 'package:ui_flutter/src/pages/listas_bitacoras.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/login.dart';
import 'package:ui_flutter/src/pages/pqrs.dart';

import '../../../main.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key}) : super(key: key);

  @override
  NavDrawerState createState() => NavDrawerState();
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
    String nombreCambio,
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
      App.localStorage.setInt(nombreCambio, 0);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => onTap,
        ),
      );
    },
  );
}

class NavDrawerState extends State<NavDrawer> {
  String usNombres = App.localStorage.getString('us_nombres') ?? '',
      usAlias = App.localStorage.getString('us_alias') ?? '';
  int cambioSede = App.localStorage.getInt('cambio_sede') ?? 0;
  int cambioEmpresa = App.localStorage.getInt('cambio_empresa') ?? 0;
  int cambioBitacora = App.localStorage.getInt('cambio_bitacora') ?? 0;
  int cambioPQRS = App.localStorage.getInt('cambio_pqrs') ?? 0;
  int cambioPublicacionesMasivas =
      App.localStorage.getInt('cambio_publicacionesmasivas') ?? 0;

  @override
  void initState() {
    setState(() {
      cambioSede = cambioSede;
      cambioEmpresa = cambioEmpresa;
      cambioBitacora = cambioBitacora;
      cambioPQRS = cambioPQRS;
      cambioPublicacionesMasivas = cambioPublicacionesMasivas;
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
              usNombres,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
              ),
            ),
            accountEmail: Text(usAlias,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 18.0,
                )),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop),
                  image: NetworkImage(
                    App.localStorage.getString('us_logo') ??
                        'https://picsum.photos/200/300',
                  ),
                  fit: BoxFit.contain),
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
            nombreCambio: 'cambio_evento',
            onTap: InicioPage(),
          ),
          Divider(),
          _createDrawerItem1(
            context: context,
            icon: Icons.apps,
            text: 'Sedes',
            cambio: cambioSede,
            nombreCambio: 'cambio_sede',
            onTap: PageListasSedes(),
          ),
          Divider(),
          _createDrawerItem1(
            context: context,
            icon: Icons.apps,
            text: 'Bitacoras',
            cambio: cambioBitacora,
            nombreCambio: 'cambio_bitacora',
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
          _createDrawerItem1(
            context: context,
            icon: Icons.contacts,
            text: 'Publicaciones masivas',
            cambio: cambioPublicacionesMasivas,
            nombreCambio: 'cambio_publicacionesmasivas',
            onTap: PagesListasPublicacionesMasivas(),
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
            context: context,
            icon: Icons.contacts,
            text: 'Quejas y Reclamos',
            cambio: cambioPQRS,
            nombreCambio: 'cambio_pqrs',
            onTap: PagesPQRS(),
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
