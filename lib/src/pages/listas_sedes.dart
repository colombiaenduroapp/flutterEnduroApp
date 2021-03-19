import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/pages/sedes_detalles.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/services/socket.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesListasSedes extends StatefulWidget {
  PagesListasSedes({Key key}) : super(key: key);

  @override
  _PagesListasSedesState createState() => _PagesListasSedesState();
}

class _PagesListasSedesState extends State<PagesListasSedes> {
  Future<dynamic> lista = ServicioSede().cargarSedes(false);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool res = false;

  List sedes1 = Hive.box('sedesdb').get('data', defaultValue: []);

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  // List sedes = new List();

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = new Text('Sedes');

  _PagesListasSedesState() {
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
  void initState() {
    _searchText = "";
    cargar();
    socket();

    // TODO: implement initState
    super.initState();
  }

// el metodo socket crea una conexion con el servidor de sockets y escucha el
// evento sedes para hacer cambios en tiempo real
  socket() async {
    SocketIO socket = await socketRes().conexion();
    socket.on('sedesres', (_) async {
      print('sedes cambio second');
      sedes1 = await ServicioSede().cargarSedes(true);
      if (mounted) {
        setState(() {
          print('cambiando');
          sedes1 = sedes1;
        });
      }
    });
  }

// el metodo cargar() carga la base de datos local en el caso de que esta se encuentre vacia
  cargar() async {
    if (!sedes1.isNotEmpty) {
      sedes1 = await ServicioSede().cargarSedes(true);
    }
  }

  @override
  void dispose() {
    _searchText;
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Nav_drawer(),
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
                return Text("${snapshot.error} error            .");
              } else {
                return Center(
                  child: Text('conecction.none'),
                );
              }

              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                List data = sedes1;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(child: _jobsListView(sedes1)),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return WidgetsGenericos.containerErrorConection(
                    context, PagesListasSedes());
              }

              break;
            case ConnectionState.waiting:
              return Center(
                child: WidgetsGenericos.shimmerList(),
              );

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
        pageSedes('Registrar', null, null),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
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
              hintStyle: TextStyle(color: Colors.white54)),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        // filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _jobsListView(data) {
    List<dynamic> sedes = new List();

    if (!(_searchText.isEmpty)) {
      for (int i = 0; i < data.length; i++) {
        if (data[i].sd_desc.toLowerCase().contains(_searchText.toLowerCase())) {
          sedes.add(data[i]);
        }
      }
    } else {
      for (int i = 0; i < data.length; i++) {
        sedes.add(data[i]);
      }
    }

    try {
      if (sedes.length > 0) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sedes.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(data[index]),
                      closeOnScroll: true,
                      child: WidgetsGenericos.itemList(
                          sedes[index]['sd_desc'],
                          null,
                          sedes[index]['sd_logo'],
                          context,
                          page_sedes_detalles(
                              sedes[index]['sd_cdgo'].toString(),
                              sedes[index]['sd_desc'].toString())),
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
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
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
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      FlatButton(
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () async {
                                            res = await ServicioSede()
                                                .deleteSede(data[index]
                                                        ['sd_cdgo']
                                                    .toString());
                                            Navigator.pop(context);
                                            WidgetsGenericos.showLoaderDialog(
                                                context,
                                                false,
                                                'Cargando...',
                                                Icons.check_circle_outlined,
                                                Colors.green);

                                            if (res) {
                                              Navigator.pop(context);
                                              WidgetsGenericos.showLoaderDialog(
                                                  context,
                                                  false,
                                                  'Eliminado Correctamente',
                                                  Icons.check_circle_outlined,
                                                  Colors.red);
                                              // await Future.delayed(
                                              //     Duration(milliseconds: 500));

                                              Navigator.pop(context);
                                              setState(() {
                                                data.removeAt(index);
                                              });
                                            } else {}
                                          }),
                                    ],
                                  );
                                },
                              );
                            }),
                      ],
                      actionPane: SlidableDrawerActionPane(),
                    );
                  }),
              SizedBox(
                height: 80,
              )
            ],
          ),
        );
      } else {
        return Center(child: WidgetsGenericos.containerEmptyData(context));
      }
    } catch (e) {}
  }
}
