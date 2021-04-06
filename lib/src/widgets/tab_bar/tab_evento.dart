import 'package:flutter/material.dart';

import '../cont_eventos.dart';

class TabEvento extends StatefulWidget {
  TabEvento({Key key}) : super(key: key);

  @override
  _TabEventoState createState() => _TabEventoState();
}

class _TabEventoState extends State<TabEvento> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: cont_eventos(),
    );
  }
}
