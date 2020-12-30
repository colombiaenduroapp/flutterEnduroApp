import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/services_ciudad.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/widgets/dialog.dart';

class pageSedes extends StatefulWidget {
  final String estado;
  final String id;
  final Sede sede;
  pageSedes(this.estado, this.id, this.sede, {Key key}) : super(key: key);

  @override
  _pageSedesState createState() => _pageSedesState();
}

class _pageSedesState extends State<pageSedes> {
  ServicioSede ser = new ServicioSede();
  Future<Ciudad> ciudad;
  String urlLogo;
  String urlJersey;
  bool res = true;
  String imgJersey = '';
  String imgLogo = '';
  String nombre_url_logo;
  String nombre_url_jersey;
  var nombreTextController = TextEditingController();
  List statelist;
  String id;
  String ciudadSel;
  File file;
  File fileJersey;
  String textValue = '?';
  @override
  void initState() {
    getCiudad();
    cargar_sede(widget.sede);

    super.initState();
  }

  @override
  void dispose() {
    cargar_sede(widget.sede);
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
        title:
            widget.estado == 'Editar' ? Text('Editar Sede') : Text('Registrar'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InicioPage(2),
                  ),
                )),
      ),
      // Contenido------
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioPage(2),
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
                            autofocus: false,
                            controller: nombreTextController,
                            decoration: new InputDecoration(
                              labelText: 'Nombre Sede',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
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
                            urlLogo == null
                                ? file == null
                                    ? Text('Seleccione una imagen')
                                    : Image.file(
                                        file,
                                        width: 300,
                                        height: 100,
                                      )
                                : Image.network(
                                    urlLogo,
                                    width: 300,
                                    height: 100,
                                  )
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
                            urlJersey == null
                                ? fileJersey == null
                                    ? Text('Seleccione una imagen')
                                    : Image.file(
                                        fileJersey,
                                        width: 300,
                                        height: 100,
                                      )
                                : Image.network(
                                    urlJersey,
                                    width: 300,
                                    height: 100,
                                  )
                          ],
                        ),

                        // input dropdown lista ciudades
                        formItemsDesign(
                          Icons.location_city,
                          dropdwon(),
                        ),
                        // Boton registrar
                        widget.estado == 'Registrar'
                            ? boton_registrar()
                            : boton_editar()

                        // fin boton--------
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

  void cargar_sede(Sede sede) {
    if (sede != null) {
      nombreTextController.text = sede.sd_desc;
      urlLogo = sede.sd_logo;
      nombre_url_logo =
          urlLogo.replaceAll("http://192.168.100.181:5000/sede/image/", "");
      urlJersey = sede.sd_jersey;
      nombre_url_jersey = urlJersey.replaceAll(
          "http://192.168.100.181:5000/sede/imagejersey/", "");
      ciudadSel = sede.cd_cdgo;
      id = sede.sd_cdgo.toString();
      print(urlLogo);
    }
  }

// diseño  de inputs form
  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: item,
        ),
      ),
    );
  }

// subir logo sede
  _chooseLogo() async {
    final picker = ImagePicker();
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    final imagen = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagen != null) {
        file = File(imagen.path);
        urlLogo = null;
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
        urlJersey = null;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCiudad() async {
    // Ciudad ciudad;
    http.Response response;
    print('object');
    try {
      response = await http
          .get(Url().getUrl() + 'ciudad')
          .timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      // ciudad = Ciudad.fromJson(jsonResponse);
      setState(() {
        statelist = jsonResponse;
      });
    } catch (e) {}

    return null;
  }

  dropdwon() {
    try {
      return statelist != null
          ? DropdownButton(
              value: ciudadSel,
              onChanged: (String value) {
                setState(() {
                  ciudadSel = value;
                  getCiudad();
                });
              },
              items: statelist.map((item) {
                // print(item['cd_desc']);
                return DropdownMenuItem(
                  value: item['id'].toString(),
                  child: Text(item['nombre']),
                );
              }).toList(),
              hint: Text('Seleccione una Ciudad'),
              isExpanded: true,
            )
          : Container(
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Cargando ciudades...')
                  ],
                ),
              ),
            );
    } catch (e) {
      return Container(
        child: Center(
          child: Column(
            children: [Text('A ocurrido  un error')],
          ),
        ),
      );
    }
    ;
  }

  Widget boton_registrar() {
    return Column(
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
                      imgLogo = base64Encode(file.readAsBytesSync());
                    }
                    // valida si hay imagen jersey y la convierte a base64
                    if (fileJersey != null) {
                      imgJersey = base64Encode(fileJersey.readAsBytesSync());
                    }
                    WidgetDialog.showLoaderDialog(
                        context, true, 'Cargando..', null);

                    try {
                      // guarda la informacion
                      res = await ser.addSede(nombreTextController.text,
                          imgLogo, imgJersey, ciudadSel);
                      // ---------------------
                      Navigator.pop(context);
                      // si se guarda la informacion muestra dialog ok y resfresca la pantalla
                      if (res) {
                        // showLoaderDialogOk(context, Icons.check_circle_outlined,
                        //     'Registrado Correctamente');
                        // WidgetDialog(false, 'Registrado Correctamente', null);
                        WidgetDialog.showLoaderDialog(
                            context,
                            false,
                            'Registrado Correctamente',
                            Icons.check_circle_outlined);
                        nombreTextController.clear();

                        nombreTextController.text = '';
                        file = null;
                        fileJersey = null;
                        await Future.delayed(Duration(milliseconds: 500));
                        // Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                pageSedes('Registrar', null, null),
                          ),
                        );
                      } else {
                        WidgetDialog.showLoaderDialog(context, false,
                            'Ha Ocurrido un error', Icons.error_outline);
                        await Future.delayed(Duration(milliseconds: 500));
                        Navigator.pop(context);
                      }
                    } catch (e) {
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
    );
  }

  Widget boton_editar() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              RaisedButton(
                onPressed: () async {
                  // valida si existe logo y lo convierte en base 64
                  if (file != null) {
                    imgLogo = base64Encode(file.readAsBytesSync());
                  }
                  // valida si hay imagen jersey y la convierte a base64
                  if (fileJersey != null) {
                    imgJersey = base64Encode(fileJersey.readAsBytesSync());
                  }
                  WidgetDialog.showLoaderDialog(
                      context, true, 'Cargando..', null);
                  res = await ser.updateSede(
                      id,
                      nombreTextController.text,
                      imgLogo,
                      nombre_url_logo,
                      imgJersey,
                      nombre_url_jersey,
                      ciudadSel);
                  Navigator.pop(context);

                  if (res) {
                    WidgetDialog.showLoaderDialog(
                        context,
                        false,
                        'Actualizado Correctamente',
                        Icons.check_circle_outlined);
                    await Future.delayed(Duration(milliseconds: 500));

                    imgLogo = '';
                    imgJersey = '';
                    file = null;
                    fileJersey = null;
                    Navigator.pop(context);
                    print(imgLogo);
                    print(imgJersey);
                  } else {
                    WidgetDialog.showLoaderDialog(context, false,
                        'Ha Ocurrido un error', Icons.error_outline);
                    await Future.delayed(Duration(milliseconds: 500));
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [Text('Actualizar')],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
