import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_flutter/src/services/services_usuario.dart';
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
  int page = 1;
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
  File file;
  String imageFile;

  @override
  void initState() {
    super.initState();
    getSedes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/fondo.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          _chooseImage();
                        },
                        child: Container(
                          child: (file == null)
                              ? Container(
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.blueGrey.shade700,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade100,
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                )
                              : Container(
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          file = null;
                                        });
                                      },
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.blueGrey.shade700,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(80),
                                        ),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(file),
                                      fit: BoxFit.cover,
                                    ),
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
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Campos obligatorios (*)',
                          style: TextStyle(color: Colors.grey[850]),
                        ),
                      ),
                      Container(
                        child: (page == 1)
                            ? Column(
                                children: [
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.person,
                                    TextFormField(
                                      controller: nombresTextController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: new InputDecoration(
                                        labelText: 'Nombres *',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Por favor ingrese los nombres';
                                        return null;
                                      },
                                    ),
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.person,
                                    TextFormField(
                                      controller: apellidosTextController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: new InputDecoration(
                                        labelText: 'Apellidos *',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Por favor ingrese los apellidos';
                                        return null;
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: WidgetsGenericos.formItemsDesign(
                                          Icons.person,
                                          DropdownButton(
                                            value: sexoSel,
                                            onChanged: (String value) {
                                              setState(() {
                                                sexoSel = value;
                                              });
                                            },
                                            items: [
                                              DropdownMenuItem(
                                                value: "F",
                                                child: Text("Femenino"),
                                              ),
                                              DropdownMenuItem(
                                                value: "M",
                                                child: Text("Masculino"),
                                              ),
                                              DropdownMenuItem(
                                                value: "O",
                                                child: Text("Otro"),
                                              )
                                            ],
                                            hint: Text('Sexo *'),
                                            isExpanded: true,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 7, top: 7, right: 20),
                                          child: Card(
                                            child: ListTile(
                                              title: DropdownButton(
                                                value: rhSel,
                                                onChanged: (String value) {
                                                  setState(() {
                                                    rhSel = value;
                                                  });
                                                },
                                                items: [
                                                  "O+",
                                                  "O-",
                                                  "A+",
                                                  "A-",
                                                  "B+",
                                                  "B-",
                                                  "AB+",
                                                  "AB-"
                                                ].map((value) {
                                                  return DropdownMenuItem(
                                                      value: value,
                                                      child: Text(value));
                                                }).toList(),
                                                hint: Text('RH *'),
                                                isExpanded: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.location_on,
                                    TextFormField(
                                      controller: direccionTextController,
                                      decoration: new InputDecoration(
                                        labelText: 'Dirección',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.phone,
                                    TextFormField(
                                      controller: telefonoTextController,
                                      keyboardType: TextInputType.phone,
                                      decoration: new InputDecoration(
                                        labelText: 'Teléfono',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.location_city,
                                    dropdown(),
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.label,
                                    TextFormField(
                                      controller: aliasTextController,
                                      decoration: new InputDecoration(
                                        labelText: 'Alias',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.alternate_email,
                                    TextFormField(
                                      controller: correoTextController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: new InputDecoration(
                                        labelText: 'Correo *',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Por favor ingrese el correo';
                                        return null;
                                      },
                                    ),
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.remove_red_eye,
                                    TextFormField(
                                      controller: contraseniaTextController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      obscureText: true,
                                      decoration: new InputDecoration(
                                        labelText: 'Contraseña *',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return 'Por favor ingrese el contraseña';
                                        return null;
                                      },
                                    ),
                                  ),
                                  WidgetsGenericos.formItemsDesign(
                                    Icons.remove_red_eye,
                                    TextFormField(
                                      controller:
                                          contraseniaValidTextController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      obscureText: true,
                                      decoration: new InputDecoration(
                                        labelText: 'Repita contraseña *',
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Por favor ingrese la contraseña';
                                        } else if (value !=
                                            contraseniaTextController.text) {
                                          return 'Las contraseñas no coinciden';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 9, left: 9),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: (page == 2)
                                    ? TextButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            page = 1;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.chevron_left,
                                        ),
                                        label: Text('Atrás'))
                                    : null,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                            Container(
                              child: (page == 1)
                                  ? TextButton(
                                      onPressed: (nombresTextController
                                                  .text.isNotEmpty &&
                                              apellidosTextController
                                                  .text.isNotEmpty &&
                                              sexoSel != null &&
                                              rhSel != null)
                                          ? () {
                                              setState(() {
                                                page = 2;
                                              });
                                            }
                                          : null,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text('Siguiente'),
                                            Icon(
                                              Icons.chevron_right,
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: (sedeSel != null &&
                                              correoTextController
                                                  .text.isNotEmpty &&
                                              contraseniaTextController
                                                  .text.isNotEmpty &&
                                              contraseniaValidTextController
                                                  .text.isNotEmpty &&
                                              contraseniaValidTextController
                                                      .text ==
                                                  contraseniaTextController
                                                      .text)
                                          ? () {
                                              _guardar();
                                            }
                                          : null,
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text('Enviar'),
                                            Icon(
                                              Icons.chevron_right,
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('¿Ya estás registrado?'),
                            TextButton(
                              onPressed: () {
                                print('iniciar sesión');
                              },
                              child: Text('Iniciar Sesión'),
                            ),
                          ],
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

  _guardar() async {
    try {
      if (file != null) imageFile = base64Encode(file.readAsBytesSync());
      WidgetsGenericos.showLoaderDialog(
          context, true, 'Cargando..', null, Colors.grey);
      bool res = await ServicioUsuario().addUsuario(
          nombresTextController.text,
          apellidosTextController.text,
          telefonoTextController.text,
          direccionTextController.text,
          imageFile,
          sedeSel,
          aliasTextController.text,
          sexoSel,
          rhSel,
          correoTextController.text,
          contraseniaTextController.text);
      Navigator.pop(context);
      if (res) {
        WidgetsGenericos.showLoaderDialog(
            context,
            false,
            'Registrado Correctamente. Debes esperar la aprobación del lider de la sede.',
            Icons.check_circle_outlined,
            Colors.green);
        setState(() {
          nombresTextController.clear();
          apellidosTextController.clear();
          telefonoTextController.clear();
          direccionTextController.clear();
          aliasTextController.clear();
          correoTextController.clear();
          contraseniaTextController.clear();
          contraseniaValidTextController.clear();
          file = null;
          imageFile = '';
          sedeSel = null;
          sexoSel = null;
          rhSel = null;
        });

        //await ServicioSede().cargarSedes(true);

        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        WidgetsGenericos.showLoaderDialog(context, false,
            'Ha Ocurrido un error', Icons.error_outline, Colors.red);
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pop(context);
      }
    } catch (e) {}
  }

  _chooseImage() async {
    final picker = ImagePicker();
    final imagen = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imagen != null) file = File(imagen.path);
    });
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
              hint: Text('Seleccione una sede *'),
              isExpanded: true,
            )
          : Container(
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text('Cargando sedes...')
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
