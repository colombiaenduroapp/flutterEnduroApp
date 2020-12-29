import 'package:flutter/material.dart';

class WidgetDialog extends StatelessWidget {
  final bool estado;
  final String texto;
  final IconData icon;

  const WidgetDialog(this.estado, this.texto, this.icon, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          estado ? CircularProgressIndicator() : Text(''),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Row(
                children: [Icon(icon), Text(texto)],
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
