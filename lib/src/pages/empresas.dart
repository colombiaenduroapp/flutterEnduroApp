import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/pages/listas_empresas.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

// class pagesEmpresa extends StatefulWidget {
//   final String em_cdgo;
//   pagesEmpresa(this.em_cdgo, {Key key}) : super(key: key);

//   @override
//   _pagesEmpresaState createState() => _pagesEmpresaState();
// }

// class _pagesEmpresaState extends State<pagesEmpresa> {

// }

class pagesEmpresa extends StatefulWidget {
  final String em_cdgo;
  final Empresa empresa;
  final String estado;
  pagesEmpresa(this.em_cdgo, this.empresa, this.estado, {Key key})
      : super(key: key);

  @override
  _pagesEmpresaState createState() => _pagesEmpresaState();
}

class _pagesEmpresaState extends State<pagesEmpresa> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nitTextController = new TextEditingController();
  TextEditingController telefonoTextController = new TextEditingController();
  TextEditingController emailTextController = new TextEditingController();
  TextEditingController descTextController = new TextEditingController();
  TextEditingController nombreTextController = new TextEditingController();

  File file;
  String id_ev_cdgo;
  String nombre_url_logo = '';
  String urlLogo = null;
  String imgLogo = null;
  bool res = false;
  int us_cdgo, us_sede_sd_cdgo;
  String us_nombres;
  @override
  void initState() {
    cargar_evento(widget.empresa);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Registrar Empresa'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => pages_listas_empresas(),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => pages_listas_empresas()),
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
                            controller: nitTextController,
                            decoration: new InputDecoration(
                              labelText: 'Nit Empresa',
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese el nit de la empresa';
                              }
                              return null;
                            },
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
                        // visualizacion imagen
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

                        formItemsDesign(
                          Icons.video_library,
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese Nombre de la empresa';
                              }
                              return null;
                            },
                            maxLines: 1,
                            autofocus: false,
                            controller: nombreTextController,
                            decoration: new InputDecoration(
                              labelText: 'Razon social o Nombre',
                              border: OutlineInputBorder(),
                            ),
                            buildCounter: null,
                          ),
                        ),

                        formItemsDesign(
                          Icons.phone,
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese un numero de telefono';
                              }
                              return null;
                            },
                            autofocus: false,
                            controller: telefonoTextController,
                            decoration: new InputDecoration(
                              labelText: 'Telefono',
                              border: OutlineInputBorder(),
                            ),
                            buildCounter: null,
                          ),
                        ),

                        formItemsDesign(
                          Icons.email_rounded,
                          TextFormField(
                            autofocus: false,
                            controller: emailTextController,
                            decoration: new InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            buildCounter: null,
                          ),
                        ),
                        formItemsDesign(
                          Icons.description,
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor ingrese Informacion';
                              }
                              return null;
                            },
                            autofocus: false,
                            controller: descTextController,
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

  void cargar_evento(Empresa empresa) {
    if (empresa != null) {
      nitTextController.text = empresa.em_nit;

      telefonoTextController.text = empresa.em_telefono;
      urlLogo = empresa.em_logo;
      nombreTextController.text = empresa.em_nombre;
      emailTextController.text = empresa.em_correo;
      descTextController.text = empresa.em_desc;
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
          if (_formKey.currentState.validate()) {
            if (file != null) {
              imgLogo = base64Encode(
                file.readAsBytesSync(),
              );
            }
            WidgetsGenericos.showLoaderDialog(
                context, true, 'Cargango...', null);
            res = await ServicioEmpresa().addEmpresa(
                nitTextController.text,
                imgLogo,
                nombreTextController.text,
                descTextController.text,
                telefonoTextController.text,
                emailTextController.text);

            if (res) {
              Navigator.pop(context);
              WidgetsGenericos.showLoaderDialog(context, false,
                  'Registrado Exitosamente', Icons.check_circle_outlined);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            } else {
              WidgetsGenericos.showLoaderDialog(
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
            WidgetsGenericos.showLoaderDialog(
                context, true, 'Cargango...', null);
            res = await ServicioEmpresa().updateEmpresa(
                widget.em_cdgo,
                nitTextController.text,
                imgLogo,
                nombreTextController.text,
                descTextController.text,
                telefonoTextController.text,
                emailTextController.text);
            if (res) {
              Navigator.pop(context);
              WidgetsGenericos.showLoaderDialog(context, false,
                  'Actualizado Exitosamente', Icons.check_circle_outlined);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              WidgetsGenericos.showLoaderDialog(
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
}
