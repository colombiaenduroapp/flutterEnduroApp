import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ui_flutter/src/services/services_pqrs.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesPQRS extends StatefulWidget {
  PagesPQRS({Key key}) : super(key: key);

  @override
  _PagesPQRSState createState() => _PagesPQRSState();
}

class _PagesPQRSState extends State<PagesPQRS> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController asuntoTextController = new TextEditingController();
  TextEditingController descTextController = new TextEditingController();
  bool res = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Registrar Queja o Reclamo'),
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
                          Icons.email,
                          TextFormField(
                            autofocus: false,
                            controller: asuntoTextController,
                            decoration: new InputDecoration(
                              labelText: 'Asunto',
                              disabledBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              return (value.isEmpty)
                                  ? 'Por favor ingrese el asunto'
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
              res = await ServicioPQRS()
                  .addPQRS(asuntoTextController.text, descTextController.text);
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
                asuntoTextController.text = '';
                descTextController.text = '';
                res = false;
              });
            } else {
              WidgetsGenericos.showLoaderDialog(context, false,
                  'Ha ocurrido un error', Icons.error_outline, Colors.red);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
