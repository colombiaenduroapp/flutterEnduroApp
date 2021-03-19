import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:ui_flutter/src/services/services_bitacora.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesBitacoraPersonal extends StatefulWidget {
  PagesBitacoraPersonal({Key key}) : super(key: key);

  @override
  _PagesBitacoraPersonalState createState() => _PagesBitacoraPersonalState();
}

class _PagesBitacoraPersonalState extends State<PagesBitacoraPersonal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController ciudadTextController = new TextEditingController();
  TextEditingController lugarTextController = new TextEditingController();
  TextEditingController descTextController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool res = false;
  List<File> listFile = [];
  List<String> listBase = [];
  // String _error = null;
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bitacora'),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Theme.of(context).cardColor,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Center(
                  child: Text('Escribir publicación',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      WidgetsGenericos.formItemsDesign(
                        Icons.location_city,
                        TextFormField(
                          autofocus: false,
                          controller: ciudadTextController,
                          decoration: new InputDecoration(
                            labelText: 'Ciudad',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese una ciudad';
                            }
                            return null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.location_on_sharp,
                        TextFormField(
                          autofocus: false,
                          controller: lugarTextController,
                          decoration: new InputDecoration(
                            labelText: 'Lugar(opcional)',
                            hintText: 'nombre del sitio o lugar visitado)',
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
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
                            labelText: 'Descripcion  publicación',
                            hintText:
                                'describe tu experiencia o información sobre el lugar visitado',
                          ),
                          buildCounter: null,
                        ),
                      ),

                      // buildGridView(),
                      Container(
                        child: images.length > 0
                            ? Center(child: viewImagesA(images))
                            : Center(
                                child: Text('No hay imagenes'),
                              ),
                      ),
                      Center(
                        child: GFButton(
                          onPressed: () async {
                            loadAssets();

                            cargarBase();
                          },
                          type: GFButtonType.outline,
                          child: Text('Agregar Imagenes'),
                        ),
                      ),

                      // ----------------------boton publicar
                      GFButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (listBase.length > 0) {
                              WidgetsGenericos.showLoaderDialog(context, true,
                                  'Cargando...', null, Colors.blue);
                              res = await ServicioBitacoras().addBitacora(
                                  ciudadTextController.text,
                                  lugarTextController.text,
                                  descTextController.text,
                                  listBase);
                              print(res);
                              if (res) {
                                Navigator.pop(context);
                                WidgetsGenericos.showLoaderDialog(
                                    context,
                                    false,
                                    'Registrado Exitosamente',
                                    Icons.check_circle_outlined,
                                    Colors.green);
                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                                WidgetsGenericos.showLoaderDialog(
                                    context,
                                    false,
                                    'Ha ocurrido un error',
                                    Icons.error_outline,
                                    Colors.red);
                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                Navigator.pop(context);
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    'Por favor seleccione al menos 1 imagen'),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          }
                        },
                        color: Theme.of(context).accentColor,
                        child: Text('Publicar'),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget viewImagesA(List<Asset> files) {
    final double runSpacing = 4;
    final double spacing = 3;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: List.generate(files.length, (index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: AssetThumb(
            asset: files[index],
            width: 100,
            height: 100,
          ),
        );
      }),
    );
  }

  cargarBase() async {
    listBase = [];
    if (null != images) {
      for (Asset asset in images) {
        ByteData byteData = await asset.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        String hola = base64.encode(imageData);
        listBase.add(hola);
      }
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
      cargarBase();
    });
  }
}
