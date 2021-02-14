import 'package:flutter/material.dart';
import 'package:ui_flutter/src/models/model_empresa.dart';
import 'package:ui_flutter/src/pages/empresas.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';

import 'empresas.dart';

class pages_empresas_detalles extends StatefulWidget {
  String em_cdgo;
  Empresa empresa;
  pages_empresas_detalles(this.em_cdgo, this.empresa, {Key key})
      : super(key: key);

  @override
  _pages_empresas_detallesState createState() =>
      _pages_empresas_detallesState();
}

class _pages_empresas_detallesState extends State<pages_empresas_detalles> {
  Future<Empresa> future_empresa;
  Empresa empresa;
  @override
  void initState() {
    future_empresa = ServicioEmpresa().searchEmpresa(widget.em_cdgo.toString());
    // TODO: implement initState
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
        future: future_empresa,
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            empresa = snapshot.data;
            return Container(
              child: Column(
                children: [
                  _imagen_evento(snapshot.data.em_logo),
                  _nombre_evento(snapshot.data.em_nombre),
                  _cont_empresa(snapshot.data)
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _imagen_evento(String url) {
    try {
      print(url);
      return url != null
          ? Container(
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

  _nombre_evento(String nombre) {
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

  _cont_empresa(Empresa empresa) {
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
          )
        ],
      ),
    );
  }
}
