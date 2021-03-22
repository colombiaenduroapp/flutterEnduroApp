import 'package:flutter/material.dart';
import 'package:ui_flutter/src/widgets/cont_inicio.dart';

class TabInicio extends StatefulWidget {
  TabInicio({Key key}) : super(key: key);

  @override
  _TabInicioState createState() => _TabInicioState();
}

class _TabInicioState extends State<TabInicio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: cont_inicio(),
    );
  }
}
