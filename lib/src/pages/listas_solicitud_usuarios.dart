import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PageListasSolicitudUsuarios extends StatefulWidget {
  PageListasSolicitudUsuarios({Key key}) : super(key: key);

  @override
  _PageListasSolicitudUsuariosState createState() =>
      _PageListasSolicitudUsuariosState();
}

class _PageListasSolicitudUsuariosState
    extends State<PageListasSolicitudUsuarios> {
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Solicitudes de usuarios');
  Icon _searchIcon = Icon(Icons.search);
  String _searchText;
  List<dynamic> usuarios = Hive.box('solicitudusuariosdb').get('data');

  _PageListasSolicitudUsuariosState() {
    _filter.addListener(() {
      setState(() {
        _searchText = (_filter.text.isEmpty) ? "" : _filter.text;
      });
    });
  }

  @override
  void initState() {
    print(usuarios);
    _searchText = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          IconButton(icon: _searchIcon, onPressed: _searchPressed),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _jobListView('hola'),
        ),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
            focusColor: Colors.white,
            hintText: "Buscar...",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Solicitudes de usuarios');
        _filter.clear();
      }
    });
  }

  Widget _jobListView(data) {}
}
