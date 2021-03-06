import 'dart:convert';
import 'dart:io';

import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/models/model_empresa.dart';
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
  String urlLogo;
  String imgLogo = '';
  String nombre_url_logo;
  var dato;
  bool res = false;
  int us_cdgo;
  String us_nombres;
  SocketIO socket;

  @override
  void initState() {
    dato = 'Empresa';
    cargar_evento(widget.empresa);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(dato),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PageListasEmpresas(),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageListasEmpresas()),
        ),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // -------------------------Formulario-----------------------

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Colors.blueGrey[50],
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // -------input nit------
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
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Razon social o Nombre',
                              ),
                              buildCounter: null,
                            ),
                          ),
                          Text(
                            dato,
                            style: TextStyle(color: Colors.black),
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
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Telefono',
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
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Email',
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
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Descripcion  Evento',
                                hintText:
                                    'Describe el evento(lugar, hora, informacion, etc)',
                              ),
                              buildCounter: null,
                            ),
                          ),

                          // -----input imagen-----
                          InkWell(
                            onTap: () {
                              _chooseLogo();
                            },
                            child: Column(
                              children: [
                                Text('Logo Sede'),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(
                                            2, 2), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          'https://dev.monsoonmedialv.com/cannalv/wp-content/uploads/2016/02/camera.placeholder.lg_.png'),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                  width: 200,
                                  height: 130,
                                  // color: Colors.grey[300],
                                  child: Container(
                                    child: urlLogo == ''
                                        ? file == null
                                            ? Text(
                                                'Seleccione un Logo',
                                                style: TextStyle(
                                                    color: Colors.black54),
                                                textAlign: TextAlign.center,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.file(
                                                  file,
                                                  width: 200,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              urlLogo,
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
                          widget.estado == 'Registrar'
                              ? boton_registrar()
                              : boton_editar()
                        ],
                      ),
                    ),
                  )
                  // -------------------------Fin formulario----------------------
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
      nombre_url_logo = urlLogo.replaceAll("sede/image/", "");
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
        urlLogo = '';
      } else {
        print('No image selected.');
      }
    });
  }

  boton_registrar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: GFButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if (file != null) {
                imgLogo = base64Encode(
                  file.readAsBytesSync(),
                );
              }
              WidgetsGenericos.showLoaderDialog(
                  context, true, 'Cargando...', null, Colors.blue);
              res = await ServicioEmpresa().addEmpresa(
                nitTextController.text,
                imgLogo,
                nombreTextController.text,
                descTextController.text,
                telefonoTextController.text,
                emailTextController.text,
              );

              if (res) {
                Navigator.pop(context);
                WidgetsGenericos.showLoaderDialog(
                    context,
                    false,
                    'Registrado Exitosamente',
                    Icons.check_circle_outlined,
                    Colors.green);
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                WidgetsGenericos.showLoaderDialog(context, false,
                    'Ha ocurrido un error', Icons.error_outline, Colors.red);
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context);
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

  boton_editar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: GFButton(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if (file != null) {
                imgLogo = base64Encode(
                  file.readAsBytesSync(),
                );
              }
              WidgetsGenericos.showLoaderDialog(
                  context, true, 'Cargando...', null, Colors.blue);
              res = await ServicioEmpresa().updateEmpresa(
                  widget.em_cdgo,
                  nitTextController.text,
                  imgLogo,
                  nombre_url_logo,
                  nombreTextController.text,
                  descTextController.text,
                  telefonoTextController.text,
                  emailTextController.text);
              if (res) {
                Navigator.pop(context);
                WidgetsGenericos.showLoaderDialog(
                    context,
                    false,
                    'Actualizado Exitosamente',
                    Icons.check_circle_outlined,
                    Colors.green);
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                WidgetsGenericos.showLoaderDialog(context, false,
                    'Ha ocurrido un error', Icons.error_outline, Colors.red);
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context);
              }
            }
          },
          icon: Icon(Icons.update_outlined),
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
