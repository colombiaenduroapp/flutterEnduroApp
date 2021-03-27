import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class PageRegister extends StatefulWidget {
  PageRegister({Key key}) : super(key: key);

  @override
  _PageRegisterState createState() => _PageRegisterState();
}

class _PageRegisterState extends State<PageRegister> {
  final _formKey = GlobalKey<FormState>();
  List statelist = [];
  var nombresTextController = TextEditingController();
  var apellidosTextController = TextEditingController();
  var telefonoTextController = TextEditingController();
  var direccionTextController = TextEditingController();
  var aliasTextController = TextEditingController();
  var correoTextController = TextEditingController();
  var contraseniaTextController = TextEditingController();
  var contraseniaValidTextController = TextEditingController();
  String sedeSel = null;
  String sexoSel = null;
  String rhSel = null;

  @override
  void initState() {
    super.initState();
    getSedes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("assets/fondo_login.jpg"),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white38,
                            Colors.amber[700],
                            Colors.orange
                          ]),
                          border:
                              Border.all(color: Colors.transparent, width: 6),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        width: 140,
                        height: 140,
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.person,
                        TextFormField(
                          controller: nombresTextController,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Nombres',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese los nombres';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.person,
                        TextFormField(
                          controller: apellidosTextController,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Apellidos',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese los apellidos';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.location_on,
                        TextFormField(
                          controller: direccionTextController,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Dirección',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese la dirección';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.phone,
                        TextFormField(
                          controller: telefonoTextController,
                          keyboardType: TextInputType.phone,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Teléfono',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese el teléfono';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.location_city,
                        dropdown(),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.label,
                        TextFormField(
                          controller: aliasTextController,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Alias',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese su alias';
                            }
                            return null;
                          },
                        ),
                      ),
                      /* 
                      Row(
                        children: [
                          Column(
                            children: [Text('hola')],
                          ),
                          Column(
                            children: [Text('mundo')],
                          )
                        ],
                      ) */
                      WidgetsGenericos.formItemsDesign(
                        Icons.alternate_email,
                        TextFormField(
                          controller: correoTextController,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Correo',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese el correo';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.remove_red_eye,
                        TextFormField(
                          controller: contraseniaTextController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Contraseña',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese la contraseña';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.remove_red_eye,
                        TextFormField(
                          controller: contraseniaValidTextController,
                          enableSuggestions: false,
                          autocorrect: false,
                          obscureText: true,
                          autofocus: false,
                          decoration: new InputDecoration(
                            labelText: 'Repita contraseña',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese la contraseña';
                            } else if (value !=
                                contraseniaTextController.text) {
                              return 'No coinciden las contraseñas';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdown() {
    try {
      return statelist.length > 0
          ? DropdownButton(
              value: sedeSel,
              onChanged: (String value) {
                setState(() {
                  sedeSel = value;
                });
              },
              items: statelist.map((item) {
                return DropdownMenuItem(
                  value: item['sd_cdgo'].toString(),
                  child: Text(item['sd_desc']),
                );
              }).toList(),
              hint: Text('Seleccione una sede'),
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

  Future getSedes() async {
    try {
      var response = await http
          .get(Url().getUrl() + 'usuarios/lista_sede')
          .timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      setState(() {
        statelist = jsonResponse;
      });
    } catch (e) {}
  }
}
