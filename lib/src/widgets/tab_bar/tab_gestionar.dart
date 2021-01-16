import 'package:flutter/material.dart';
import 'package:ui_flutter/src/widgets/cont_gestionar.dart';

class tab_gestionar extends StatefulWidget {
  tab_gestionar({Key key}) : super(key: key);

  @override
  _tab_gestionarState createState() => _tab_gestionarState();
}

class _tab_gestionarState extends State<tab_gestionar> {
  @override
  Widget build(BuildContext context) {
    return cont_gestionar();
  }
}
