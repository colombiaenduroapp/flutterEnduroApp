import 'package:flutter/material.dart';
import 'package:ui_flutter/src/services/services_vehiculo.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';
import 'vehiculos.dart';

class PagesVehiculoDetalles extends StatefulWidget {
  String ve_cdgo;
  dynamic vehiculo;
  PagesVehiculoDetalles(this.ve_cdgo, this.vehiculo, {Key key})
      : super(key: key);

  @override
  _PagesVehiculoDetallesState createState() => _PagesVehiculoDetallesState();
}

class _PagesVehiculoDetallesState extends State<PagesVehiculoDetalles> {
  Future<dynamic> futureVehiculo;
  dynamic vehiculo;

  @override
  void initState() {
    futureVehiculo =
        ServicioVehiculos().searchVehiculo(widget.ve_cdgo.toString());

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
              builder: (context) => PageVehiculos(),
            ),
          ),
        ),
      ]),
      body: FutureBuilder(
        future: futureVehiculo,
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
                  child: Center(
                    child: Container(
                      child: Column(
                        children: [
                          _encabezadopropietario(),
                          _placaydesc(),
                          _documentos(),
                        ],
                      ),
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

  _encabezadopropietario() {
    try {
      return Container(
          decoration: BoxDecoration(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: WidgetsGenericos.loadImage(
                    widget.vehiculo['us_logo'],
                  ),
                ),
              ),
              Text(widget.vehiculo['us_alias'],
                  style: Theme.of(context).textTheme.headline5)
            ],
          ));
    } catch (e) {
      print(e);
    }
  }

  _placaydesc() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(
          color: Colors.grey,
          width: 0.5,
          style: BorderStyle.solid,
        )),
      ),
      child: Column(
        children: [
          Text('Vehiculo', style: Theme.of(context).textTheme.overline),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Text('Placa:',
                    style: Theme.of(context).textTheme.overline), //Text

                Text(widget.vehiculo['ve_placa'],
                    style: Theme.of(context).textTheme.headline6)
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Text('Descripcion del vehiculo',
                    style: Theme.of(context).textTheme.overline),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                          style: BorderStyle.solid)),
                  child: Text(widget.vehiculo['ve_desc'],
                      textAlign: TextAlign.center),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _documentos() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text('Soat y Tecnomecanica',
              style: Theme.of(context).textTheme.overline),
        ],
      ),
    );
  }
}
