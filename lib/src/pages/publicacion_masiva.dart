import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:ui_flutter/src/services/services_publicacionesMasivas.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagePublicacionMasiva extends StatefulWidget {
  PagePublicacionMasiva({Key key}) : super(key: key);

  @override
  _PagePublicacionMasivaState createState() => _PagePublicacionMasivaState();
}

class _PagePublicacionMasivaState extends State<PagePublicacionMasiva> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController linkTextController = new TextEditingController();
  TextEditingController descTextController = new TextEditingController();
  bool res = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicaciones Masivas'),
      ),
      body: SingleChildScrollView(
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
                      Text(
                        'Registrar Link',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.email,
                        TextFormField(
                          autofocus: false,
                          controller: linkTextController,
                          decoration: new InputDecoration(
                            labelText: 'Link',
                            disabledBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            return (value.isEmpty)
                                ? 'Por favor ingrese el link'
                                : null;
                          },
                        ),
                      ),
                      WidgetsGenericos.formItemsDesign(
                        Icons.description,
                        TextFormField(
                          autofocus: false,
                          controller: descTextController,
                          maxLength: 400,
                          maxLines: 8,
                          decoration: new InputDecoration(
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
                      SimpleUrlPreview(
                        url:
                            'https://www.facebook.com/vhie140695/videos/827575657826310',
                        titleLines: 2,
                        descriptionLines: 2,
                        imageLoaderColor: Colors.white,
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
    );
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
              WidgetsGenericos.showLoaderDialog(
                  context, true, 'Cargando...', null, Colors.blue);
              res = await ServicioPublicacionesMasivas().addPublicacionMasiva(
                descTextController.text,
                linkTextController.text,
              );
            }
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
                linkTextController.text = '';
                descTextController.text = '';
                res = false;
              });
            } else {
              Navigator.pop(context);
              WidgetsGenericos.showLoaderDialog(context, false,
                  'Ha ocurrido un error', Icons.error_outline, Colors.red);
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
