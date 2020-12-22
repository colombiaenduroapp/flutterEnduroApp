import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/services/services_eventos.dart';

import 'inicio.dart';

class pagesEventos extends StatefulWidget {
  final String ev_cdgo;
  final Evento evento;
  final String estado;
  pagesEventos(this.ev_cdgo, this.evento, this.estado, {Key key})
      : super(key: key);

  @override
  _pagesEventosState createState() => _pagesEventosState();
}

class _pagesEventosState extends State<pagesEventos> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController descTextController = new TextEditingController();
  TextEditingController lugarTextController = new TextEditingController();
  TextEditingController urlTeextController = new TextEditingController();
  DateTime selected_fecha_inicio = DateTime.now();
  DateTime selected_fecha_fin = DateTime.now();
  File file;
  String id_ev_cdgo;
  String nombre_url_logo = '';
  String urlLogo = '';
  String imgLogo = '';
  bool res = false;
  int us_cdgo, us_sede_sd_cdgo;
  String us_nombres;
// utilizar preferencias
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    us_cdgo = prefs.getInt('us_cdgo') ?? 0;
    us_nombres = prefs.getString('us_nombres') ?? '';
    us_sede_sd_cdgo = prefs.getInt('us_sede_sd_cdgo') ?? 0;
  }

  @override
  void initState() {
    nombre_url_logo =
        urlLogo.replaceAll("http://192.168.100.181:5000/evento/image/", "");
    cargar_evento(widget.evento);
    addStringToSF();
    id_ev_cdgo = widget.ev_cdgo;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Registrar Evento'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InicioPage(1),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioPage(1),
          ),
        ),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        formItemsDesign(
                          Icons.description,
                          TextFormField(
                            autofocus: false,
                            controller: descTextController,
                            decoration: new InputDecoration(
                              labelText: 'Nombre Evento',
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
                        formItemsDesign(
                          Icons.date_range_outlined,
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RaisedButton(
                                onPressed: () => _selectDate(context,
                                    selected_fecha_inicio), // Refer step 3
                                child: Text(
                                  'Seleccione fecha de inicio ',
                                ),
                                color: Colors.blue[200],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${selected_fecha_inicio}".split(' ')[0],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        formItemsDesign(
                          Icons.date_range_outlined,
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              RaisedButton(
                                onPressed: () => _selectDate_fin(context,
                                    selected_fecha_fin), // Refer step 3
                                child: Text(
                                  'Seleccione fecha de finalizacion',
                                ),
                                color: Colors.blue[200],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${selected_fecha_fin}".split(' ')[0],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        formItemsDesign(
                          Icons.location_city_outlined,
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese Informacion';
                              }
                              return null;
                            },
                            autofocus: false,
                            controller: lugarTextController,
                            maxLength: 1000,
                            maxLines: 5,
                            decoration: new InputDecoration(
                              labelText: 'Descripcion  Evento',
                              hintText:
                                  'Describe el evento(lugar, hora, informacion, etc)',
                              border: OutlineInputBorder(),
                            ),
                            buildCounter: null,
                          ),
                        ),
                        formItemsDesign(
                          Icons.video_library,
                          TextFormField(
                            controller: urlTeextController,
                            decoration: new InputDecoration(
                              labelText: 'Url video Youtube',
                              border: OutlineInputBorder(),
                            ),
                            buildCounter: null,
                          ),
                        ),
                        formItemsDesign(
                          Icons.image,
                          Column(
                            children: [
                              RaisedButton(
                                color: Colors.blue[200],
                                onPressed: () {
                                  _chooseLogo();
                                },
                                child: Column(
                                  children: [
                                    Text('Seleccione imagen de evento')
                                  ],
                                ),
                              ),
                            ],
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
                        widget.estado == 'Registrar'
                            ? boton_registrar()
                            : boton_editar()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// cargar evento
  void cargar_evento(Evento evento) {
    if (evento != null) {
      descTextController.text = evento.ev_desc;
      // selected_fecha_inicio = DateTime.parse(evento.ev_fecha_inicio);
      print(selected_fecha_inicio);
      lugarTextController.text = evento.ev_lugar;
      urlLogo = evento.ev_img;
      urlTeextController.text = evento.ev_url_video;

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

  _selectDate(BuildContext context, DateTime selected) async {
    final DateTime picked = await showDatePicker(
      locale: Locale("es"),
      context: context,
      initialDate: selected, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selected)
      setState(() {
        selected_fecha_inicio = picked;
      });
  }

  _selectDate_fin(BuildContext context, DateTime selected) async {
    final DateTime picked = await showDatePicker(
      locale: Locale("es"),
      context: context,
      initialDate: selected, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selected)
      setState(() {
        selected_fecha_fin = picked;
      });
  }

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

  boton_registrar() {
    return Container(
      padding: EdgeInsets.all(15),
      child: RaisedButton(
        onPressed: () async {
          print(us_sede_sd_cdgo + us_cdgo);
          print(us_sede_sd_cdgo);
          if (_formKey.currentState.validate()) {
            if (file != null) {
              imgLogo = base64Encode(
                file.readAsBytesSync(),
              );
              showLoaderDialog(context, true, 'Cargango...', null);
              res = await ServicioEvento().addEvento(
                us_sede_sd_cdgo,
                us_cdgo,
                descTextController.text,
                selected_fecha_inicio,
                selected_fecha_fin,
                lugarTextController.text,
                imgLogo,
                urlTeextController.text,
              );
            } else {
              return _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text('Por favor seleccione una imagen')));
            }

            if (res) {
              Navigator.pop(context);
              print('true');
              showLoaderDialog(context, false, 'Registrado Exitosamente',
                  Icons.check_circle_outlined);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            } else {
              showLoaderDialog(
                  context, false, 'Ha ocurrido un error', Icons.error_outline);
              Navigator.pop(context);
            }
          }
        },
        color: Colors.blue[200],
        child: Text('Registrar'),
      ),
    );
  }

  boton_editar() {
    return Container(
      padding: EdgeInsets.all(15),
      child: RaisedButton(
        onPressed: () async {
          print(id_ev_cdgo);
          if (_formKey.currentState.validate()) {
            if (file != null) {
              print(file);
              imgLogo = base64Encode(
                file.readAsBytesSync(),
              );
            }
            // print(imgLogo);

            showLoaderDialog(context, true, 'Cargango...', null);
            res = await ServicioEvento().updateSede(
              id_ev_cdgo,
              us_sede_sd_cdgo,
              us_cdgo,
              descTextController.text,
              selected_fecha_inicio,
              selected_fecha_fin,
              lugarTextController.text,
              imgLogo,
              nombre_url_logo,
              urlTeextController.text,
            );

            if (res) {
              Navigator.pop(context);
              print('true');
              showLoaderDialog(context, false, 'Actualizado Exitosamente',
                  Icons.check_circle_outlined);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              // print('false');
              showLoaderDialog(
                  context, false, 'Ha ocurrido un error', Icons.error_outline);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            }
          }
        },
        color: Colors.blue[200],
        child: Text('Editar'),
      ),
    );
  }

  showLoaderDialog(
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
