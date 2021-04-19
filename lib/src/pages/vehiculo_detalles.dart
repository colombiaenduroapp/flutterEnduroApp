import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/empresas.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'empresas.dart';

class PagesVehiculoDetalles extends StatefulWidget {
  String ve_cdgo;
  dynamic vehiculo;
  PagesVehiculoDetalles(this.ve_cdgo, this.vehiculo, {Key key})
      : super(key: key);

  @override
  _PagesVehiculoDetallesState createState() => _PagesVehiculoDetallesState();
}

class _PagesVehiculoDetallesState extends State<PagesVehiculoDetalles> {
  Future<dynamic> futureEmpresa;
  dynamic vehiculo;

  @override
  void initState() {
    futureEmpresa = ServicioEmpresa().searchEmpresa(widget.ve_cdgo.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehiculo'), actions: <Widget>[
        IconButton(
          icon: new Icon(Icons.edit_outlined),
          iconSize: 30,
          tooltip: 'Editar',
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  pagesEmpresa(widget.ve_cdgo, vehiculo, 'Editar'),
            ),
          ),
        ),
      ]),
      body: FutureBuilder(
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
                vehiculo = snapshot.data;
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        _imagenEvento(snapshot.data.em_logo),
                      ],
                    ),
                  ),
                );
              } else {
                return WidgetsGenericos.containerErrorConection(context,
                    PagesVehiculoDetalles(widget.ve_cdgo, widget.vehiculo));
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
}
