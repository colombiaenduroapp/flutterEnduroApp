import 'package:flutter/material.dart';
import 'package:ui_flutter/src/widgets/cont_gestionar.dart';

class TabGestionar extends StatefulWidget {
  TabGestionar({Key key}) : super(key: key);

  @override
  _TabGestionarState createState() => _TabGestionarState();
}

class _TabGestionarState extends State<TabGestionar> {
  @override
  Widget build(BuildContext context) {
    return ContGestionar();
  }
}
