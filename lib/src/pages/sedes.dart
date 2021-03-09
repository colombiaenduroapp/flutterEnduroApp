import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/models/model_sede.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/listas_sedes.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/services_ciudad.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

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
  String url = Url().getUrl();
  Future<Ciudad> ciudad;
  String urlLogo;
  String urlJersey;
  bool res = false;
  String imgJersey = '';
  String imgLogo = '';
  String nombre_url_logo;
  String nombre_url_jersey;
  var nombreTextController = TextEditingController();
  List statelist;
  String id;
  String ciudadSel = null;
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            widget.estado == 'Editar' ? Text('Editar Sede') : Text('Registrar'),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PagesListasSedes(),
                  ),
                )),
        // actions: [
        //   widget.estado == 'Registrar' ? boton_registrar() : boton_editar()
        // ],
      ),
      // Contenido------
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PagesListasSedes(),
          ),
        ),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blueGrey[50],
                    // formulario
                    child: Form(
                      key: _formKey,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // input nombre sede
                          WidgetsGenericos.formItemsDesign(
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

                          WidgetsGenericos.formItemsDesign(
                            Icons.location_city,
                            dropdwon(),
                          ),

                          // ------------------------------
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _chooseLogo();
                                  },
                                  child: Column(
                                    children: [
                                      Text('Logo Sede'),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: 130,
                                        height: 130,
                                        // color: Colors.grey[300],
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: 2,
                                                blurRadius: 1,
                                                offset: Offset(2,
                                                    2), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(80),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://dev.monsoonmedialv.com/cannalv/wp-content/uploads/2016/02/camera.placeholder.lg_.png'))),

                                        child: urlLogo == null
                                            ? file == null
                                                ? Text('')
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0),
                                                    child: Image.file(
                                                      file,
                                                      width: 300,
                                                      height: 300,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(80.0),
                                                child: Image.network(
                                                  urlLogo,
                                                  width: 200,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _chooseJersey();
                                  },
                                  child: Column(
                                    children: [
                                      Text('Imagen Sede'),
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: Offset(2,
                                                    2), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    'https://dev.monsoonmedialv.com/cannalv/wp-content/uploads/2016/02/camera.placeholder.lg_.png'))),
                                        margin: EdgeInsets.only(top: 10),
                                        width: 130,
                                        height: 130,
                                        // color: Colors.grey[300],
                                        child: Center(
                                          child: urlJersey == null
                                              ? fileJersey == null
                                                  ? Text('')
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.file(
                                                          fileJersey,
                                                          width: 200,
                                                          height: 200,
                                                          fit: BoxFit.cover),
                                                    )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    urlJersey,
                                                    width: 200,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // -----------------------------

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
      ),
    );
  }

  void cargar_sede(Sede sede) {
    if (sede != null) {
      nombreTextController.text = sede.sd_desc;
      urlLogo = sede.sd_logo;
      nombre_url_logo = urlLogo.replaceAll(url + "sede/image/", "");
      urlJersey = sede.sd_jersey;
      nombre_url_jersey = urlJersey.replaceAll(url + "sede/imagejersey/", "");
      ciudadSel = sede.cd_cdgo;
      id = sede.sd_cdgo.toString();
    }
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http.get(
        Url().getUrl() + 'ciudad',
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      // ciudad = Ciudad.fromJson(jsonResponse);
      setState(() {
        statelist = jsonResponse;
      });
    } catch (e) {}

    return null;
  }

  Widget dropdwon() {
    try {
      return statelist != null
          ? DropdownButton(
              value: ciudadSel,
              onChanged: (String value) {
                this.setState(() {
                  ciudadSel = value;
                  getCiudad();
                });
              },
              items: statelist.map((item) {
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
  }

  Widget boton_registrar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: GFButton(
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

              try {
                if (ciudadSel != null) {
                  WidgetsGenericos.showLoaderDialog(
                      context, true, 'Cargando..', null, Colors.grey);
                  // guarda la informacion
                  res = await ser.addSede(
                    nombreTextController.text,
                    imgLogo,
                    imgJersey,
                    ciudadSel,
                  );

                  // ---------------------
                  Navigator.pop(context);
                  // si se guarda la informacion muestra dialog ok y resfresca la pantalla
                  if (res) {
                    WidgetsGenericos.showLoaderDialog(
                        context,
                        false,
                        'Registrado Correctamente',
                        Icons.check_circle_outlined,
                        Colors.green);
                    nombreTextController.clear();

                    nombreTextController.text = '';
                    file = null;
                    fileJersey = null;
                    await ServicioSede().cargarSedes(true);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PagesListasSedes(),
                      ),
                    );
                  } else {
                    WidgetsGenericos.showLoaderDialog(
                        context,
                        false,
                        'Ha Ocurrido un error',
                        Icons.error_outline,
                        Colors.red);
                    await Future.delayed(Duration(milliseconds: 500));
                    Navigator.pop(context);
                  }
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Assign a GlobalKey to the Scaffold'),
                    duration: Duration(seconds: 3),
                  ));
                }
              } catch (e) {
                return Text('Ha ocurrido un error');
              }
            }
          },
          icon: Icon(Icons.check),
          type: GFButtonType.solid,
          shape: GFButtonShape.pills,
          color: Theme.of(context).accentColor,
          child: Text(
            'Registrar',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget boton_editar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: GFButton(
          onPressed: () async {
            // valida si existe logo y lo convierte en base 64
            if (file != null) {
              imgLogo = base64Encode(file.readAsBytesSync());
            }
            // valida si hay imagen jersey y la convierte a base64
            if (fileJersey != null) {
              imgJersey = base64Encode(fileJersey.readAsBytesSync());
            }
            WidgetsGenericos.showLoaderDialog(
                context, true, 'Cargando..', null, Colors.grey);
            res = await ser.updateSede(id, nombreTextController.text, imgLogo,
                nombre_url_logo, imgJersey, nombre_url_jersey, ciudadSel);
            Navigator.pop(context);

            if (res) {
              WidgetsGenericos.showLoaderDialog(
                  context,
                  false,
                  'Actualizado Correctamente',
                  Icons.check_circle_outlined,
                  Colors.green);
              await Future.delayed(Duration(milliseconds: 500));

              imgLogo = '';
              imgJersey = '';
              file = null;
              fileJersey = null;
              Navigator.pop(context);
            } else {
              WidgetsGenericos.showLoaderDialog(context, false,
                  'Ha Ocurrido un error', Icons.error_outline, Colors.red);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.check),
          type: GFButtonType.solid,
          shape: GFButtonShape.pills,
          color: Theme.of(context).accentColor,
          child: Text(
            'Actualizar',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
