import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_flutter/src/pages/empresas_detalles.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'empresas.dart';

class pages_listas_empresas extends StatefulWidget {
  pages_listas_empresas({Key key}) : super(key: key);

  @override
  _pages_listas_empresasState createState() => _pages_listas_empresasState();
}

class _pages_listas_empresasState extends State<pages_listas_empresas> {
  Future<EmpresaList> lista = ServicioEmpresa().getEmpresa();
  EmpresaList emplist;
  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";

  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = new Text('Empresa');
  bool res = true;
  @override
  void initState() {
    // TODO: implement initS
    super.initState();
  }

  _pages_listas_empresasState() {
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
        body: FutureBuilder<EmpresaList>(
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
                  emplist = snapshot.data;

                  return _jobsListView(emplist);
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
            context, pagesEmpresa(null, null, 'Registrar')),
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
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _jobsListView(data) {
    List tempList = new List();
    if (!(_searchText.isEmpty)) {
      for (int i = 0; i < emplist.empresas.length; i++) {
        if (emplist.empresas[i].em_nombre
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(data.empresas[i]);
        }
      }
    } else {
      for (int i = 0; i < emplist.empresas.length; i++) {
        tempList.add(data.empresas[i]);
      }
    }

    try {
      if (tempList.length > 0) {
        return ListView.builder(
          itemCount: tempList.length,
          itemBuilder: (context, index) {
            return Slidable(
              key: ValueKey(emplist.empresas[index]),
              closeOnScroll: true,
              child: WidgetsGenericos.itemList(
                tempList[index].em_nombre,
                tempList[index].em_logo,
                context,
                pages_empresas_detalles(
                  tempList[index].em_cdgo.toString(),
                  tempList[index],
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
                                    res = await ServicioEmpresa().deleteEmpresa(
                                        data.empresas[index].em_cdgo
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
                                        data.empresas.removeAt(index);
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
          },
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
