import 'package:flutter/material.dart';
import 'package:ui_flutter/src/services/services_pqrs.dart';

class PagesListasPqrs extends StatefulWidget {
  PagesListasPqrs({Key key}) : super(key: key);

  @override
  _PagesListasPqrsState createState() => _PagesListasPqrsState();
}

class _PagesListasPqrsState extends State<PagesListasPqrs> {
  Widget _appBarTitle = new Text('Quejas y Reclamos');
  List pqrs;

  @override
  void initState() {
    cargar();
    super.initState();
  }

  cargar() async {
    pqrs = await ServicioPQRS().getPQRS(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: _jobListView(pqrs),
            )
          ],
        ),
      ),
    );
  }

  Widget _jobListView(List<dynamic> pqrs) {}
}
