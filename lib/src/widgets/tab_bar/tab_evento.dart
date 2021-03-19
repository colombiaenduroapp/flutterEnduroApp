import 'package:flutter/material.dart';

import '../cont_eventos.dart';

class tab_evento extends StatefulWidget {
  tab_evento({Key key}) : super(key: key);

  @override
  _tab_eventoState createState() => _tab_eventoState();
}

class _tab_eventoState extends State<tab_evento> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: cont_eventos(),
    );
  }
}
