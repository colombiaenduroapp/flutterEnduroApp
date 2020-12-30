import 'package:flutter/material.dart';

class WidgetDialog {
  static Widget showLoaderDialog(
      BuildContext context, bool estado, String texto, IconData icon) {
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
