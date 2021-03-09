import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/models/model_empresa.dart';
import 'package:ui_flutter/src/pages/empresas.dart';
import 'package:ui_flutter/src/services/service_convenio.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';
import 'package:http/http.dart' as http;
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'empresas.dart';

class pages_empresas_detalles extends StatefulWidget {
  String em_cdgo;
  dynamic empresa;
  pages_empresas_detalles(this.em_cdgo, this.empresa, {Key key})
      : super(key: key);

  @override
  _pages_empresas_detallesState createState() =>
      _pages_empresas_detallesState();
}

class _pages_empresas_detallesState extends State<pages_empresas_detalles> {
  Future<Empresa> futureEmpresa;
  Empresa empresa;
  String textEror;
  List statelist;
  String ciudadSel = null;
  TextEditingController descTextController = new TextEditingController();

  @override
  void initState() {
    futureEmpresa = ServicioEmpresa().searchEmpresa(widget.em_cdgo.toString());
    getCiudad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Empresa'), actions: <Widget>[
        IconButton(
          icon: new Icon(Icons.edit_outlined),
          iconSize: 30,
          tooltip: 'Editar',
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  pagesEmpresa(widget.em_cdgo, empresa, 'Editar'),
            ),
          ),
        ),
      ]),
      body: FutureBuilder<Empresa>(
        future: futureEmpresa,
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                empresa = snapshot.data;
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        _imagenEvento(snapshot.data.em_logo),
                        _nombreEvento(snapshot.data.em_nombre),
                        _contEmpresa(snapshot.data),
                        _contConvenios(),
                      ],
                    ),
                  ),
                );
              } else {
                return WidgetsGenericos.containerErrorConection(context,
                    pages_empresas_detalles(widget.em_cdgo, widget.empresa));
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
        },
      ),
    );
  }

  _imagenEvento(String url) {
    try {
      return url != null
          ? InkWell(
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
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: FadeInImage.assetNetwork(
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  placeholder: 'assets/loading_img.gif',
                  image: url,
                  imageErrorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      child: Icon(Icons.image_not_supported_rounded),
                    );
                  },
                ),
              ),
            )
          : Container(
              child: Icon(Icons.business_outlined),
              width: double.infinity,
              height: 220,
            );
    } catch (e) {
      print(e);
    }
  }

  _nombreEvento(String nombre) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(
        nombre,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  _contEmpresa(Empresa empresa) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Nit: ',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                ),
              ),
              Text(
                empresa.em_nit,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Telefono: ',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                ),
              ),
              Text(
                empresa.em_telefono,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Email: ',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 20,
                ),
              ),
              Text(
                empresa.em_correo,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Descripcion de la empresa',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 1)),
                padding: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                child: Text(empresa.em_desc),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future getCiudad() async {
    // Ciudad ciudad;
    http.Response response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http.get(
        Url().getUrl() + 'tipo_convenios/' + widget.em_cdgo,
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
                setState(() {
                  ciudadSel = value;
                  Navigator.pop(context);
                  dialog();
                });
              },
              items: statelist.map((item) {
                return DropdownMenuItem(
                  value: item['tp_cdgo'].toString(),
                  child: Text(item['tp_desc']),
                );
              }).toList(),
              hint: Text('Seleccione un tipo Convenio'),
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

  _contConvenios() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Convenios',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  dialog();
                },
                elevation: 4.0,
                fillColor: Theme.of(context).accentColor,
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
          Column(
            children: [
              listaConvenios(empresa),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
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
            // text form descripcion
            TextFormField(
              autofocus: false,
              controller: descTextController,
              maxLength: 1000,
              maxLines: 5,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 0.5,
                  ),
                ),
                labelStyle: TextStyle(fontSize: 15),
                suffixStyle: TextStyle(fontSize: 15),
                labelText: 'Descripcion Del convenio',
                hintText: 'Describe el convenio',
              ),
              buildCounter: null,
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
            ciudadSel = null;
            descTextController.text = '';
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text(
            'Registrar',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            if (ciudadSel == null) {
              setState(() {
                textEror = 'Por favor seleccione el tipo de convenio';
              });
              Navigator.pop(context);
              dialog();
            } else if (descTextController.text == '') {
              setState(() {
                textEror = 'Por favor agregue una descripción';
              });
              Navigator.pop(context);
              dialog();
            } else {
              bool res = false;

              WidgetsGenericos.showLoaderDialog(
                  context, true, 'Cargando...', null, Colors.blue);
              res = await ServicioConvenio().addConvenio(
                  descTextController.text, widget.em_cdgo, ciudadSel);
              if (res) {
                textEror = null;
                ciudadSel = null;
                descTextController.text = '';
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
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        pages_empresas_detalles(widget.em_cdgo, widget.empresa),
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

  Widget listaConvenios(Empresa sede) {
    if (sede.convenios.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: sede.convenios.length,
        itemBuilder: (context, index) {
          if (sede.convenios != null) {
            return InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: new Text(sede.convenios[index].tp_desc),
                          content: new Text(sede.convenios[index].co_desc),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'Cerrar',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
              },
              child: Container(
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text(
                    '${sede.convenios[index].tp_desc}',
                    // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: InkWell(
                    onTap: () {},
                    child: Icon(Icons.more_vert_outlined),
                  ),
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
}
