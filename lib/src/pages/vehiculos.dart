import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/services/services_pqrs.dart';
import 'package:ui_flutter/src/services/services_vehiculo.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PageVehiculos extends StatefulWidget {
  PageVehiculos({Key key}) : super(key: key);

  @override
  _PageVehiculosState createState() => _PageVehiculosState();
}

class _PageVehiculosState extends State<PageVehiculos> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController placaTextController = new TextEditingController();
  TextEditingController descTextController = new TextEditingController();
  DateTime selected_fecha_inicio;
  String urlSoat = null;
  File fileSoat;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selected_fecha_tecno;
  String urlTecno = null;
  String imgTecno, imgSoat;
  File fileTecno;
  bool res = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Registrar Vehiculo'),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.blueGrey.shade50,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        WidgetsGenericos.formItemsDesign(
                          Icons.sports_motorsports_outlined,
                          TextFormField(
                            autofocus: false,
                            controller: placaTextController,
                            decoration: new InputDecoration(
                              labelText: 'Placa',
                              disabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              return (value.isEmpty)
                                  ? 'Por favor ingrese una placa'
                                  : null;
                            },
                          ),
                        ),
                        WidgetsGenericos.formItemsDesign(
                          Icons.motorcycle_sharp,
                          TextFormField(
                            autofocus: false,
                            controller: descTextController,
                            maxLength: 400,
                            maxLines: 5,
                            decoration: new InputDecoration(
                              hintStyle: TextStyle(color: Colors.black26),
                              hintText:
                                  'Por vafor describre tu vehiculo: modelo, marca, año, etc',
                              labelText: 'Descripción',
                              disabledBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              return (value.isEmpty)
                                  ? 'Por favor ingrese la descripción'
                                  : null;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Column soat------------
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GFButton(
                                    onPressed: () => _selectDate(context,
                                        selected_fecha_inicio), // Refer step 3
                                    child: Text(
                                      'Fecha Ven Soat ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(
                                    selected_fecha_inicio != null
                                        ? "${selected_fecha_inicio}"
                                            .split(' ')[0]
                                        : '',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _chooseJersey('soat');
                                    },
                                    child: Column(
                                      children: [
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
                                            child: urlSoat == null
                                                ? fileSoat == null
                                                    ? Text('')
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.file(
                                                            fileSoat,
                                                            width: 200,
                                                            height: 200,
                                                            fit: BoxFit.cover),
                                                      )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      urlSoat,
                                                      width: 200,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Text('Foto Soat'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Column Tecno---------------
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GFButton(
                                    onPressed: () => _selectDateTecno(context,
                                        selected_fecha_tecno), // Refer step 3
                                    child: Text(
                                      'Fecha Ven Tecno ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text(
                                    selected_fecha_tecno != null
                                        ? "${selected_fecha_tecno}"
                                            .split(' ')[0]
                                        : '',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _chooseJersey('tecno');
                                    },
                                    child: Column(
                                      children: [
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
                                            child: urlTecno == null
                                                ? fileTecno == null
                                                    ? Text('')
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.file(
                                                            fileTecno,
                                                            width: 200,
                                                            height: 200,
                                                            fit: BoxFit.cover),
                                                      )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      urlTecno,
                                                      width: 200,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Text('Foto TecnoMecanica'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        botonRegistrar(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _chooseJersey(String tipo) async {
    final picker = ImagePicker();
    // file = await ImagePicker.pickImage(source: ImageSource.camera);
    final imagen = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagen != null) {
        if (tipo == 'soat') {
          fileSoat = File(imagen.path);
          urlSoat = null;
        } else if (tipo == 'tecno') {
          fileTecno = File(imagen.path);
          urlTecno = null;
        }
      } else {
        print('No image selected.');
      }
    });
  }

  _selectDate(BuildContext context, DateTime selected) async {
    DateTime initial = DateTime.now();
    final DateTime picked = await showDatePicker(
      locale: Locale("es"),
      context: context,
      initialDate: initial, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selected)
      setState(() {
        selected_fecha_inicio = picked;
      });
  }

  _selectDateTecno(BuildContext context, DateTime selected) async {
    DateTime initial = DateTime.now();
    final DateTime picked = await showDatePicker(
      locale: Locale("es"),
      context: context,
      initialDate: initial, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selected)
      setState(() {
        selected_fecha_tecno = picked;
      });
  }

  botonRegistrar() {
    return Container(
      margin: EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: GFButton(
          child: Text(
            'Enviar',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          icon: Icon(Icons.send),
          type: GFButtonType.solid,
          shape: GFButtonShape.pills,
          color: Theme.of(context).accentColor,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if (fileSoat != null) {
                imgSoat = base64Encode(
                  fileSoat.readAsBytesSync(),
                );
              }
              if (fileTecno != null) {
                imgTecno = base64Encode(
                  fileTecno.readAsBytesSync(),
                );
              }
              if (selected_fecha_inicio != null) {
                WidgetsGenericos.showLoaderDialog(
                    context, true, 'Cargando...', null, Colors.blue);
                res = await ServicioVehiculos().addVehiculos(
                  placaTextController.text,
                  descTextController.text,
                  selected_fecha_inicio,
                  imgSoat,
                  selected_fecha_tecno,
                  imgTecno,
                );

                if (res) {
                  Navigator.pop(context);
                  WidgetsGenericos.showLoaderDialog(
                      context,
                      false,
                      'Enviado Exitosamente',
                      Icons.check_circle_outlined,
                      Colors.green);
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.pop(context);
                  setState(() {
                    placaTextController.text = '';
                    descTextController.text = '';
                    selected_fecha_tecno = null;
                    selected_fecha_inicio = null;
                    fileSoat = null;
                    fileTecno = null;
                    res = false;
                  });
                } else {
                  Navigator.pop(context);
                  WidgetsGenericos.showLoaderDialog(context, false,
                      'Ha ocurrido un error', Icons.error_outline, Colors.red);
                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.pop(context);
                }
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(
                      'Por favor seleciona la fecha de vencimiento de el soat'),
                  duration: Duration(seconds: 3),
                ));
              }
            }
          },
        ),
      ),
    );
  }
}
