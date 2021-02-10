import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ui_flutter/src/pages/conocenos.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PageLogin extends StatefulWidget {
  PageLogin({Key key}) : super(key: key);

  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.cyan[200]));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("assets/fondo_login.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 1.3,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(20.0),
                // border: Border.all(color: Colors.white, width: 5.0),
                color: Colors.black12.withOpacity(0.1),
              ),

              // Formulario------
              child: Center(
                child: Form(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bienvenido--------
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(20)),
                        ),
                        width: double.infinity,
                        height: 100,
                        child: Center(
                          child: Text(
                            'Colombia Enduro',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      // ------------

                      // Logo-------
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          child: Image(
                            image: AssetImage('assets/icons/descarga32.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.email_sharp,
                        TextFormField(
                          autofocus: false,
                          // controller: nombreTextController,
                          decoration: new InputDecoration(
                            labelText: 'Correo Electronico',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese un Email ';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.email_sharp,
                        TextFormField(
                          autofocus: false,
                          // controller: nombreTextController,
                          decoration: new InputDecoration(
                            labelText: 'Contraseña',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese un Email ';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: GFButton(
                            type: GFButtonType.solid,
                            shape: GFButtonShape.pills,
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      InicioPage(1),
                                ),
                              );
                            },
                            child: Text(
                              'Iniciar Sesión',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: GFButton(
                            type: GFButtonType.outline,
                            shape: GFButtonShape.pills,
                            color: Theme.of(context).accentColor,
                            onPressed: () {},
                            child: Text(
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: GFButton(
                            type: GFButtonType.outline,
                            shape: GFButtonShape.pills,
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PageConocenos(),
                                ),
                              );
                            },
                            child: Text(
                              'Conocenos',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ----------------
            ),
          ),
        ),
      ),
    );
  }
}
