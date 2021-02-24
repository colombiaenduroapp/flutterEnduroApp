import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui_flutter/src/models/model_evento.dart';
import 'package:ui_flutter/src/pages/eventos.dart';
import 'package:ui_flutter/src/pages/eventos_detalles.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ui_flutter/src/services/services_eventos.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class pages_listas_eventos extends StatefulWidget {
  pages_listas_eventos({Key key}) : super(key: key);

  @override
  _pages_listas_eventosState createState() => _pages_listas_eventosState();
}

class _pages_listas_eventosState extends State<pages_listas_eventos> {
  Future<EventosList> lista = ServicioEvento().getEventos();
  EventosList eventolist;
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = new Text('Eventos');
  bool res = true;
  @override
  void initState() {
    // TODO: implement initS
    super.initState();
  }

  _pages_listas_eventosState() {
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
        appBar: AppBar(
          title: _appBarTitle,
          actions: [
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
          ],
        ),
        body: FutureBuilder<EventosList>(
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
                  eventolist = snapshot.data;

                  return _jobsListView(eventolist);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return WidgetsGenericos.containerErrorConection(
                      context, pages_listas_eventos());
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
            context, pagesEventos(null, null, 'Registrar')),
      );
    } catch (exception) {
      return Center(
        child:
            Text('Ha ocurrido un error de conexion o No hay datos por mostrar'),
      );
    }
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

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget _jobsListView(data) {
    List teventolist = new List();
    if (!(_searchText.isEmpty)) {
      for (int i = 0; i < eventolist.eventos.length; i++) {
        if (eventolist.eventos[i].ev_desc
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          teventolist.add(data.eventos[i]);
        }
      }
    } else {
      for (int i = 0; i < eventolist.eventos.length; i++) {
        teventolist.add(data.eventos[i]);
      }
    }

    try {
      if (teventolist.length > 0) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: teventolist.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(eventolist.eventos[index]),
                    closeOnScroll: true,
                    child: WidgetsGenericos.itemList(
                      teventolist[index].ev_desc,
                      teventolist[index].ev_estado_ev == 1
                          ? 'Dias faltantes:${teventolist[index].ev_faltante.toString()}'
                          : teventolist[index].ev_estado_ev == 0
                              ? 'En Curso'
                              : teventolist[index].ev_estado_ev == 2
                                  ? 'Finalizado'
                                  : null,
                      teventolist[index].ev_img,
                      context,
                      page_eventos_detalles(teventolist[index].ev_cdgo
                          // teventolist[index],
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
                                            color: Colors.white, fontSize: 20),
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
                                          res = await ServicioEvento()
                                              .deleteEvento(data
                                                  .eventos[index].ev_cdgo
                                                  .toString());
                                          Navigator.pop(context);
                                          WidgetsGenericos.showLoaderDialog(
                                              context,
                                              false,
                                              'Cargando...',
                                              Icons.check_circle_outlined,
                                              Colors.blue);

                                          if (res) {
                                            Navigator.pop(context);
                                            WidgetsGenericos.showLoaderDialog(
                                                context,
                                                false,
                                                'Eliminado Correctamente',
                                                Icons.check_circle_outlined,
                                                Colors.green);

                                            // await Future.delayed(
                                            //     Duration(milliseconds: 500));

                                            Navigator.pop(context);
                                            await setState(() {
                                              data.eventos.removeAt(index);
                                            });
                                          } else {
                                            Navigator.pop(context);
                                            WidgetsGenericos.showLoaderDialog(
                                                context,
                                                false,
                                                ' Ha ocurrido un error',
                                                Icons.error_outline,
                                                Colors.red);
                                          }
                                        }),
                                  ],
                                );
                              },
                            );
                          }),
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
