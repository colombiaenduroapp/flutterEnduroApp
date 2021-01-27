import 'package:flutter/material.dart';
import 'package:ui_flutter/src/widgets/cont_inicio.dart';

class tab_inicio extends StatefulWidget {
  tab_inicio({Key key}) : super(key: key);

  @override
  _tab_inicioState createState() => _tab_inicioState();
}

class _tab_inicioState extends State<tab_inicio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: cont_inicio(),
    );
  }
}
