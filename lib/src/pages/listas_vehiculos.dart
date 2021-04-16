import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/pages/vehiculos.dart';
import 'package:ui_flutter/src/services/services_vehiculo.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PageListasVehiculos extends StatefulWidget {
  PageListasVehiculos({Key key}) : super(key: key);

  @override
  _PageListasVehiculosState createState() => _PageListasVehiculosState();
}

class _PageListasVehiculosState extends State<PageListasVehiculos> {
  Future<dynamic> lista = ServicioVehiculos().getVehiculos();
  List velist = Hive.box('vehiculosdb').get('data', defaultValue: []);
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = new Text('Mis Vehiculos');
  bool res = true;
  var dato;
  @override
  void initState() {
    cargar();
    socket();
    super.initState();
  }

  // el metodo socket crea una conexion con el servidor de sockets y escucha el
// evento sedeempresas para hacer cambios en tiempo real
  socket() async {
    App.conexion.on('vehiculosres', (_) async {
      velist = await ServicioVehiculos().getVehiculos();
      if (mounted) {
        setState(
          () {
            velist = velist;
          },
        );
      }
    });
  }

// el metodo cargar() carga la base de datos local en el caso de que esta se encuentre vacia
  cargar() async {
    if (!velist.isNotEmpty) {
      velist = await ServicioVehiculos().getVehiculos();
    }
  }

  _PageListasEmpresasState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";

          // filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: _appBarTitle,
          actions: [
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ],
        ),
        body: FutureBuilder(
          future: lista,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                if (snapshot.hasError) {
                  return Text("${snapshot.error} error        .");
                } else {
                  return Center(
                    child: Text('conecction.none'),
                  );
                }

                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return _jobsListView(velist);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return Center(
                    child: Text('No hay empresas Registradas'),
                  );
                }

                break;
              case ConnectionState.waiting:
                return Center(child: WidgetsGenericos.shimmerList());

                break;
              case ConnectionState.active:
                return Center(
                  child: Text('conecction.Active'),
                );

                break;
              default:
            }
          },
        ),
        floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
          context,
          PageVehiculos(),
        ),
      );
    } catch (exception) {
      return Center(
        child:
            Text('Ha ocurrido un error de conexion o No hay datos por mostrar'),
      );
    }
  }

  void _searchPressed() {
    setState(
      () {
        if (this._searchIcon.icon == Icons.search) {
          this._searchIcon = new Icon(Icons.close);
          this._appBarTitle = new TextField(
            controller: _filter,
            autofocus: true,
            style: TextStyle(color: Colors.white),
            decoration: new InputDecoration(
              fillColor: Colors.white,
              // filled: true,
              // prefixIcon: new Icon(
              //   Icons.search,
              //   color: Colors.white,
              // ),
              contentPadding: const EdgeInsets.all(20),
              focusColor: Colors.white,
              hintText: "Buscar:",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          );
        } else {
          this._searchIcon = new Icon(Icons.search);
          this._appBarTitle = new Text('Search Example');
          // filteredNames = names;
          _filter.clear();
        }
      },
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget _jobsListView(data) {
    List tvelist = new List();
    if (!(_searchText.isEmpty)) {
      for (int i = 0; i < velist.length; i++) {
        if (velist[i]['ve_placa'].toLowerCase().contains(
              _searchText.toLowerCase(),
            )) {
          tvelist.add(data[i]);
        }
      }
    } else {
      for (int i = 0; i < velist.length; i++) {
        tvelist.add(data[i]);
      }
    }

    try {
      if (tvelist.length > 0) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: tvelist.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(velist[index]),
                    closeOnScroll: true,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  Offset(1, 1), // changes position of shadow
                            ),
                          ],
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFc3c3c3),
                              width: 0.6,
                            ),
                          )),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFc3c3c3),
                                  width: 0.4,
                                ),
                              ),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  width: 30,
                                  height: 30,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(80.0),
                                    child: WidgetsGenericos.loadImage(
                                      tvelist[index]['us_logo'],
                                    ),
                                  ),
                                ),
                                Text(
                                  tvelist[index]['us_alias'],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Text('Placa: ',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                Text(
                                  tvelist[index]['ve_placa'],
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFFc3c3c3),
                                  width: 0.4,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tvelist[index]['dif_soat'] < 0
                                    ? Text(
                                        'Soat Vencido  hace: ${tvelist[index]['dif_soat'] * -1} dias ',
                                        style: (TextStyle(color: Colors.red)))
                                    : Text(
                                        'Venc Soat: ${tvelist[index]['ve_fecha_soat']}'),
                                tvelist[index]['dif_tecno'] < 0
                                    ? Text(
                                        'Tecno Vencida  hace: ${tvelist[index]['dif_tecno'] * -1} dias ',
                                        style: (TextStyle(color: Colors.red)))
                                    : Text(
                                        'Venc Tecno: ${tvelist[index]['ve_fecha_tecno']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        icon: Icons.delete_outline_rounded,
                        caption: 'Eliminar',
                        color: Colors.red,

                        //not defined closeOnTap so list will get closed when clicked
                        onTap: () async {
                          showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).primaryColor,
                                title: Text(
                                  'Advertencia!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                  'Estas seguro de eliminar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      WidgetsGenericos.showLoaderDialog(
                                          context,
                                          false,
                                          'Cargando...',
                                          Icons.check_circle_outlined,
                                          Colors.blue);
                                      Navigator.pop(context);

                                      if (res) {
                                        Navigator.pop(context);
                                        WidgetsGenericos.showLoaderDialog(
                                            context,
                                            false,
                                            'Eliminado Correctamente',
                                            Icons.check_circle_outlined,
                                            Colors.green);
                                        await Future.delayed(
                                          Duration(milliseconds: 500),
                                        );

                                        Navigator.pop(context);
                                        setState(
                                          () {
                                            data.removeAt(index);
                                          },
                                        );
                                      } else {}
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                    actionPane: SlidableDrawerActionPane(),
                  );
                },
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        );
      } else {
        return Container(
          child: Center(
            child: WidgetsGenericos.containerEmptyData(context),
          ),
        );
      }
    } catch (e) {}
  }
}
