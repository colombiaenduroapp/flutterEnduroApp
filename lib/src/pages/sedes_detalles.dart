import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/models/model_sede.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';
import 'package:http/http.dart' as http;

class page_sedes_detalles extends StatefulWidget {
  final String data;
  final String nombre;
  page_sedes_detalles(this.data, this.nombre, {Key key}) : super(key: key);

  @override
  _page_sedes_detallesState createState() => _page_sedes_detallesState();
}

class _page_sedes_detallesState extends State<page_sedes_detalles> {
  Future<Sede> searchSede;
  Sede sede;
  String id;
  List statelist;
  List userlist;
  String textEror;
  TextEditingController descTextController = new TextEditingController();
  String cargoSel = null;
  String userSel = null;
  DateTime selected_fecha = DateTime.now();

  int us_perfil = App.localStorage.getInt('us_perfil');
  @override
  void initState() {
    getCargo();
    getUsuario();
    searchSede = ServicioSede().searchSede(widget.data);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombre),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.edit_outlined),
            iconSize: 30,
            tooltip: 'Editar',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => pageSedes('Editar', id, sede),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<Sede>(
            future: searchSede,
            builder: (context, snapshot) {
              sede = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  if (snapshot.hasError) {
                    return Text("${snapshot.error} error.");
                  } else {
                    return Center(
                      child: Text('conecction.none'),
                    );
                  }

                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return Container(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              _imagen_fondo(screen, snapshot.data.sd_jersey),
                              Column(
                                children: [
                                  SizedBox(
                                    height: screen.height / 3.0,
                                  ),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: new BorderRadius.vertical(
                                            top: Radius.circular(70))),
                                    child: Text(''),
                                  ),
                                  Container(
                                    color: Theme.of(context).primaryColor,
                                    // padding: EdgeInsets.only(top: 80),

                                    child: Column(
                                      children: [
                                        // Texto Nombre Sede
                                        nombre_sede(snapshot.data.sd_desc,
                                            snapshot.data.cd_desc)
                                        // -----------------
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SafeArea(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: screen.height / 4.2,
                                      ),
                                      _imagen_perfil(snapshot.data.sd_logo),
                                    ],
                                  ),
                                ),
                              ),
                              // este contenedor invisible se superpone a los demas wigdets para poder hacer fullscreen de la imagen de fondo
                              Container(
                                width: double.infinity,
                                height: screen.height / 3.8,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            WidgetsGenericos.fullDialogImage(
                                                snapshot.data.sd_jersey),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          // boton add mesa trabajo y renovar mesa
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mesa de trabajo:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    if (us_perfil == 3)
                                      GFButton(
                                          onPressed: () {
                                            dialogRenovar();
                                          },
                                          elevation: 4.0,
                                          color: Colors.red,
                                          child: Text('Renovar mesa'),
                                          shape: GFButtonShape.pills),
                                    if (us_perfil > 1)
                                      RawMaterialButton(
                                        onPressed: () {
                                          dialog();
                                        },
                                        elevation: 4.0,
                                        fillColor:
                                            Theme.of(context).accentColor,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 25.0,
                                        ),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          future_mesa(searchSede),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return WidgetsGenericos.containerErrorConection(context,
                        page_sedes_detalles(widget.data, widget.nombre));
                  }
                  break;

                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  return Center(
                    child: Text('conecction.Active'),
                  );

                  break;
              }
            }),
      ),
    );
  }

  Widget future_mesa(Future<Sede> searchSede) {
    return SingleChildScrollView(
      child: FutureBuilder<Sede>(
        future: searchSede,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Sede data = snapshot.data;
            return lista_mesa(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget lista_mesa(Sede sede) {
    if (sede.mesas.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: sede.mesas.length,
        itemBuilder: (context, index) {
          if (sede.mesas != null) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black26, width: 0.5),
                ),
              ),
              child: ListTile(
                leading: Icon(Icons.verified_user),
                title: Text(
                  '${sede.mesas[index].us_nombres}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '${sede.mesas[index].us_alias}   -${sede.mesas[index].ca_desc}-'),
                trailing: InkWell(
                  onTap: () {},
                  child: Icon(Icons.more_vert_outlined),
                ),
              ),
            );
          } else {
            return Container(
                child: ListTile(
              title: Text('vacio'),
            ));
          }
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
            child: Center(
          child: Text(
            'No se han agregado integrantes a la mesa de trabajo',
            style: TextStyle(color: Colors.black26),
          ),
        )),
      );
    }
  }

  Widget _imagen_perfil(String url) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                WidgetsGenericos.fullDialogImage(url),
            fullscreenDialog: true,
          ),
        );
      },
      child: Center(
        child: Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(color: Colors.white, width: 5.0),
          ),
        ),
      ),
    );
  }

  Widget _imagen_fondo(Size screen, String url) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                WidgetsGenericos.fullDialogImage(url),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        height: screen.height / 2.6,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/loading_img.gif',
          image: url,
          fit: BoxFit.cover,

          //   // En esta propiedad colocamos el alto de nuestra imagen
          width: double.infinity,
        ),
      ),
    );
  }

  Widget nombre_sede(String nombre, String ciudad) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            Text(
              nombre,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text('Ciudad: ' + ciudad)
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black26, width: 2.0),
          ),
        ),
      ),
    );
  }

  Future getCargo() async {
    // Ciudad ciudad;
    print(widget.data);
    http.Response response;
    try {
      print(widget.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http
          .get(
            Url().getUrl() + 'tipo_cargos/' + widget.data,
            // headers: {
            //   "x-access-token": prefs.getString('token'),
            // },
          )
          .timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      print(jsonResponse);
      // ciudad = Ciudad.fromJson(jsonResponse);
      setState(() {
        statelist = jsonResponse;
        print(jsonResponse);
      });
    } catch (e) {}

    return null;
  }

  Future getUsuario() async {
    // Ciudad ciudad;
    http.Response response;
    try {
      print(widget.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http
          .get(
            Url().getUrl() + 'usuarios/mesa_trabajo/' + widget.data,
            // headers: {
            //   "x-access-token": prefs.getString('token'),
            // },
          )
          .timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      print(jsonResponse);
      // ciudad = Ciudad.fromJson(jsonResponse);
      setState(() {
        userlist = jsonResponse;
      });
    } catch (e) {}

    return null;
  }

  Widget dropdwon() {
    try {
      return statelist != null
          ? DropdownButton(
              value: cargoSel,
              onChanged: (String value) {
                setState(() {
                  cargoSel = value;
                  Navigator.pop(context);
                  dialog();
                });
              },
              items: statelist.map((item) {
                return DropdownMenuItem(
                  value: item['ca_cdgo'].toString(),
                  child: Text(item['ca_desc']),
                );
              }).toList(),
              hint: Text('Seleccione un tipo Cargo'),
              isExpanded: true,
            )
          : Container(
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Cargando Convenios...')
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

  Widget dropdwonUser() {
    try {
      return userlist != null
          ? DropdownButton(
              value: userSel,
              onChanged: (String value) {
                setState(() {
                  userSel = value;
                  Navigator.pop(context);
                  dialog();
                });
              },
              items: userlist.map((item) {
                return DropdownMenuItem(
                  value: item['us_cdgo'].toString(),
                  child: Text(item['us_alias']),
                );
              }).toList(),
              hint: Text('Seleccione un usuario'),
              isExpanded: true,
            )
          : Container(
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Cargando Convenios...')
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
        selected_fecha = picked;
        Navigator.pop(context);
        dialog();
      });
  }

  dialogRenovar() {
    AlertDialog alert1 = AlertDialog(
      title: Text('¿Estas Seguro?'),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Renovar la mesa de trabajo implica que se borraran todos los integrantes de la mesa')
          ],
        ),
      ),
      actions: [
        GFButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        GFButton(
          child: Text(
            'Renovar',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            bool res = false;
            WidgetsGenericos.showLoaderDialog(
                context, true, 'Cargando...', null, Colors.blue);
            res = await ServicioSede().deleteMesa(widget.data);
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
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      page_sedes_detalles(widget.data, widget.nombre),
                ),
              );
            }
          },
        )
      ],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert1;
      },
    );
  }

  dialog() {
    AlertDialog alert = AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Registrar Convenio',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Divider(),
            // dorpdown tipo convenio
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: dropdwon(),
                  ),
                ],
              ),
            ),
            // dorpdown usuario
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: dropdwonUser(),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: SizedBox(
                        width: double.infinity,
                        child: GFButton(
                          onPressed: () => _selectDate(
                              context, selected_fecha), // Refer step 3
                          child: Text(
                            'Seleccione fecha de inicio ',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          color: Theme.of(context).accentColor,
                        ))),
                Text(
                  "${selected_fecha}".split(' ')[0],
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            // mensaje error
            Center(
              child: Text(textEror == null ? '' : textEror,
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            )
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            textEror = null;
            cargoSel = null;
            descTextController.text = '';
            Navigator.of(context).pop(false);
          },
        ),
        GFButton(
          child: Text(
            'Registrar',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            if (cargoSel == null) {
              setState(() {
                textEror = 'Por favor seleccione el tipo de cargo';
              });
              Navigator.pop(context);
              dialog();
            } else if (userSel == null) {
              setState(() {
                textEror = 'Por favor seleccione un usuario';
              });
              Navigator.pop(context);
              dialog();
            } else {
              bool res = false;

              WidgetsGenericos.showLoaderDialog(
                  context, true, 'Cargando...', null, Colors.blue);
              res = await ServicioSede()
                  .addMesa(selected_fecha, cargoSel, userSel, widget.data);
              if (res) {
                textEror = null;
                cargoSel = null;
                userSel = null;
                Navigator.pop(context);
                WidgetsGenericos.showLoaderDialog(
                    context,
                    false,
                    'Registrado Exitosamente',
                    Icons.check_circle_outlined,
                    Colors.green);
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        page_sedes_detalles(widget.data, widget.nombre),
                  ),
                );
              } else {
                Navigator.pop(context);
                WidgetsGenericos.showLoaderDialog(context, false,
                    'Ha ocurrido un error', Icons.error_outline, Colors.red);
                await Future.delayed(Duration(milliseconds: 500));
                Navigator.pop(context);
              }
            }
          },
        ),
      ],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
