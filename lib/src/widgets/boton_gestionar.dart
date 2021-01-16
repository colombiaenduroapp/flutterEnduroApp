import 'package:flutter/material.dart';

class BotonGestionar {
  Widget boton_gestionar(IconData icon, String texto) {
    return Container(
      width: 100,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.blueGrey[300],
          ),
          Text(
            texto,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
