import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';

class pageSedes extends StatefulWidget {
  pageSedes({Key key}) : super(key: key);

  @override
  _pageSedesState createState() => _pageSedesState();
}

class _pageSedesState extends State<pageSedes> {
  ServicioCiudad ser = new ServicioCiudad();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    file = null;

    super.dispose();
  }

  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Registrar Sede'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InicioPage(),
                  ),
                )),
      ),
      // Contenido------
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioPage(),
          ),
        ),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // titulo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      // child: Image(image: null),
                    ),
                  ],
                ),
                // fin titulo
                new Container(
                  // formulario
                  child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        // input nombre sede
                        formItemsDesign(
                          Icons.person,
                          TextFormField(
                            controller: nombreTextController,
                            decoration: new InputDecoration(
                              labelText: 'Nombre Sede',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese un nombre';
                              }
                              return null;
                            },
                          ),
                        ),
                        // input file logo
                        formItemsDesign(
                          Icons.image,
                          RaisedButton(
                            onPressed: () {
                              _chooseLogo();
                            },
                            child: Column(
                              children: [Text('Subir Logo')],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            file == null
                                ? Text('Seleccione una imagen')
                                : Image.file(
                                    file,
                                    width: 300,
                                    height: 100,
                                  ),
                          ],
                        ),
                        // input file subir jersey
                        formItemsDesign(
                          Icons.image,
                          RaisedButton(
                            onPressed: () {
                              _chooseJersey();
                            },
                            child: Column(
                              children: [Text('Subir Jersey')],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            fileJersey == null
                                ? Text('Seleccione una imagen')
                                : Image.file(
                                    fileJersey,
                                    width: 300,
                                    height: 100,
                                  ),
                          ],
                        ),
                        // input dropdown lista ciudades
                        formItemsDesign(
                          Icons.location_city,
                          DropdownButton(
                            onChanged: (String value) {
                              setState(() {
                                ciudadSel = value;
                              });
                            },
                            items: lista.map((String ciudad) {
                              return DropdownMenuItem(
                                value: ciudad,
                                child: Text(ciudad),
                              );
                            }).toList(),
                            hint: Text('Seleccione una Ciudad'),
                          ),
                        ),
                        // Boton registrar
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  RaisedButton(
                                    color: Colors.blue[400],
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        // valida si existe logo y lo convierte en base 64
                                        if (file != null) {
                                          imgLogo = base64Encode(
                                              file.readAsBytesSync());
                                        }
                                        // valida si hay imagen jersey y la convierte a base64
                                        if (fileJersey != null) {
                                          imgJersey = base64Encode(
                                              fileJersey.readAsBytesSync());
                                        }
                                        showLoaderDialog(context);
                                        try {
                                          // guarda la informacion
                                          res = await ser.addSede(
                                              nombreTextController.text,
                                              imgLogo,
                                              imgJersey,
                                              '14');
                                          // ---------------------
                                          Navigator.pop(context);
                                          // si se guarda la informacion muestra dialog ok y resfresca la pantalla
                                          if (res) {
                                            showLoaderDialogOk(
                                                context,
                                                Icons.check_circle_outlined,
                                                'Registrado Correctamente');
                                            nombreTextController.clear();

                                            nombreTextController.text = '';
                                            file = null;
                                            fileJersey = null;
                                            await Future.delayed(
                                                Duration(milliseconds: 500));
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    pageSedes(),
                                              ),
                                            );
                                          } else {
                                            showLoaderDialogOk(
                                                context,
                                                Icons.error_outline,
                                                'Ha Ocurrido un error');
                                            await Future.delayed(
                                                Duration(milliseconds: 500));
                                            Navigator.pop(context);
                                          }
                                        } catch (e) {
                                          print('object');
                                          return Text('Ha ocurrido un error');
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [Text('Registrar')],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Fin formulario----------
                )
              ],
              // -----
            ),
          ),
        ),
      ),
    );
  }

// Dialog cargando
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Row(
                children: [Text("Loading...")],
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

// dialog  resgistrado
  showLoaderDialogOk(BuildContext context, IconData icon, String text) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [Icon(icon), Text(text)],
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

// diseño  de inputs form
  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  bool res = null;
  String imgJersey = '';
  String imgLogo = '';
  String ciudadSel = '';
  var nombreTextController = TextEditingController();
  var lista = ['Cartagena', 'cartago', 'Bogota'];
  File file;
  File fileJersey;
  String textValue = '?';

// subir logo sede
  _chooseLogo() async {
    final picker = ImagePicker();
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    final imagen = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagen != null) {
        file = File(imagen.path);
        print(file);
      } else {
        print('No image selected.');
      }
    });
  }

  // subir jersey sede
  _chooseJersey() async {
    final picker = ImagePicker();
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    final imagen = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagen != null) {
        fileJersey = File(imagen.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
