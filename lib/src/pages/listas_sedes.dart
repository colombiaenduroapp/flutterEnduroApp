import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ui_flutter/src/models/model_sede.dart';
import 'package:ui_flutter/src/pages/inicio.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/pages/sedes_detalles.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/widgets/cont_sedes.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesListasSedes extends StatefulWidget {
  PagesListasSedes({Key key}) : super(key: key);

  @override
  _PagesListasSedesState createState() => _PagesListasSedesState();
}

class _PagesListasSedesState extends State<PagesListasSedes> {
  Future<SedesList> lista = ServicioSede().cargarSedes();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool res = false;
  final TextEditingController _filter = new TextEditingController();

  String _searchText;

  @override
  void initState() {
    _searchText = "";

    // TODO: implement initState
    super.initState();
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
        appBar: AppBar(
          title: Text('Sedes'),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InicioPage(0),
                    ),
                  )),
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
                  SedesList data = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: TextField(
                            controller: _filter,
                            // autofocus: true,
                            // style: TextStyle(color: Colors.white),
                            decoration: new InputDecoration(
                              // fillColor: Colors.white,
                              // filled: true,
                              prefixIcon: new Icon(
                                Icons.search,
                                // color: Colors.white,
                              ),
                              contentPadding: const EdgeInsets.only(top: 15),
                              focusColor: Colors.white,
                              hintText: "Buscar:",
                              // hintStyle: TextStyle(color: Colors.white54),
                            ),
                          ),
                        ),
                        Container(child: _jobsListView(data)),
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
        )

        // body: Container(
        //   child: cont_sedes(),
        // ),
        // floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
        //   context,
        //   pageSedes('Registrar', null, null),
        // ),
        );
  }

  Widget _jobsListView(data) {
    List sedes = new List();
    if (!(_searchText.isEmpty)) {
      for (int i = 0; i < data.sedes.length; i++) {
        if (data.sedes[i].sd_desc
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          sedes.add(data.sedes[i]);
        }
      }
    } else {
      for (int i = 0; i < data.sedes.length; i++) {
        sedes.add(data.sedes[i]);
      }
    }

    try {
      if (sedes.length > 0) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  // scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sedes.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(data.sedes[index]),
                      closeOnScroll: true,
                      child: WidgetsGenericos.itemList(
                          sedes[index].sd_desc,
                          null,
                          sedes[index].sd_logo,
                          context,
                          page_sedes_detalles(sedes[index].sd_cdgo.toString(),
                              sedes[index].sd_desc.toString())),
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
                                                .deleteSede(data
                                                    .sedes[index].sd_cdgo
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
                                              await setState(() {
                                                data.sedes.removeAt(index);
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

                    // WidgetsGenericos.ItemList(
                    //     data.sedes[index].sd_desc,
                    //     data.sedes[index].sd_logo,
                    //     context,
                    //     page_sedes_detalles(data.sedes[index].sd_cdgo.toString()));
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
