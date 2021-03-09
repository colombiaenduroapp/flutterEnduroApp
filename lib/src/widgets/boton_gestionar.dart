import 'package:flutter/material.dart';

class BotonGestionar {
  Widget boton_gestionar(
      IconData icon, String texto, BuildContext context, Widget pagina) {
    return Container(
      width: 100,
      height: 100,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => pagina,
          ),
        ),
        splashColor: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Theme.of(context).accentColor,
            ),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).textSelectionColor),
            ),
          ],
        ),
      ),
    );
  }
}
