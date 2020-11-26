import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';
import '';

class pageSedes extends StatefulWidget {
  pageSedes({Key key}) : super(key: key);

  @override
  _pageSedesState createState() => _pageSedesState();
}

class _pageSedesState extends State<pageSedes> {
  ServicioCiudad ser = new ServicioCiudad();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    file = null;
    // TODO: implement dispose
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
        title: Text('Sedes'),
      ),
      // Contenido------
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // titulo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'CREAR SEDE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                ),
              ],
            ),
            // fin titulo
            new Container(
              // formulario
              child: new Form(
                key: _formKey,
                child: new Column(children: <Widget>[
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
                                print(ciudadSel);
                                if (_formKey.currentState.validate()) {
                                  // If the form is valid, display a Snackbar.
                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //     content: Text('Processing Data')));
                                  if (imgLogo.isEmpty) {
                                    imgLogo =
                                        base64Encode(file.readAsBytesSync());
                                  }
                                  if (imgJersey.isEmpty) {
                                    imgJersey =
                                        base64Encode(file.readAsBytesSync());
                                  }
                                  res = await ser.addSede(
                                      nombreTextController.text,
                                      imgLogo,
                                      imgJersey,
                                      '14');
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
                  )
                ]),
              ),
              // Fin formulario----------
            )
          ],
          // -----
        ),
      ),
    );
  }

// diseño  de inputs form
  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  // ---------------------
  _cargando(bool res) {
    if (res) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  bool res = null;
  String imgJersey = '';
  String imgLogo = '';
  String ciudadSel = '';
  final nombreTextController = TextEditingController();
  var lista = ['Cartagena', 'cartago', 'Bogota'];
  File file;
  File fileJersey;
  String textValue = '?';
  final String phpEndPoint = 'http://192.168.100.181:5000/ciudad/image';
// subir logo sede
  _chooseLogo() async {
    final picker = ImagePicker();
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    final imagen = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagen != null) {
        file = File(imagen.path);
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
