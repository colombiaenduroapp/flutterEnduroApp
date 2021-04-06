import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:ui_flutter/main.dart';

import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/services/services_publicacionesMasivas.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesListasPublicacionesMasivas extends StatefulWidget {
  PagesListasPublicacionesMasivas({Key key}) : super(key: key);

  @override
  _PagesListasPublicacionesMasivasState createState() =>
      _PagesListasPublicacionesMasivasState();
}

class _PagesListasPublicacionesMasivasState
    extends State<PagesListasPublicacionesMasivas> {
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Publicaciones masivas');
  Icon _searchIcon = Icon(Icons.search);
  List<dynamic> publicaciones =
      Hive.box('publicacionesmasivasdb').get('data') ?? [];
  String _searchText;
  bool res = false;

  _PagesListasPublicacionesMasivasState() {
    _filter.addListener(() {
      setState(() {
        _searchText = (_filter.text.isEmpty) ? "" : _filter.text;
      });
    });
  }

  @override
  void initState() {
    _searchText = "";
    super.initState();
  }

  socket() async {
    App.conexion.on('publicacionesmasivasresres', (_) async {
      publicaciones =
          await ServicioPublicacionesMasivas().getPublicacionesMasivas();
      if (mounted) {
        setState(() {
          print('cambiando');
          publicaciones = publicaciones;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          IconButton(icon: _searchIcon, onPressed: _searchPressed),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: _jobListView(publicaciones),
            )
          ],
        ),
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
            contentPadding: const EdgeInsets.all(20),
            focusColor: Colors.white,
            hintText: "Buscar...",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Quejas y Reclamos');
        _filter.clear();
      }
    });
  }

  Widget _jobListView(data) {
    if (data.length > 0) {
      List<dynamic> listaPqrs = (_searchText.isNotEmpty)
          ? publicaciones
              .where((f) => f['pqrs_asunto']
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()))
              .toList()
          : data;
      return SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listaPqrs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black45,
                          width: 0.5,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 5.0,
                              offset: Offset(1.0, 0.75))
                        ],
                        color: Colors.white),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.black45, width: 0.5),
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data[index]['us_alias'],
                                  style: Theme.of(context).textTheme.headline6),
                              Text(data[index]['sd_desc'],
                                  style: Theme.of(context).textTheme.bodyText1)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Text(data[index]['pu_desc'],
                                        textAlign: TextAlign.start),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        50, //cambiar a valor dinamico tamaño de pantalla
                                    child: SimpleUrlPreview(
                                      url: data[index]['pu_link'],
                                      titleLines: 2,
                                      descriptionLines: 2,
                                      imageLoaderColor: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        data[index]['ep_desc'] != null
                            ? Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: data[index][
                                              'pu_estado_publicacion_ep_cdgo'] ==
                                          3
                                      ? Colors.red
                                      : data[index][
                                                  'pu_estado_publicacion_ep_cdgo'] ==
                                              2
                                          ? Colors.green
                                          : Colors.blue,
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black45, width: 0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Estado: ' + data[index]['ep_desc'],
                                        // style: Theme.of(context).textTheme.caption,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        data[index]['ep_desc'] != null
                            ? Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: GFButton(
                                      onPressed: () async {
                                        WidgetsGenericos.showLoaderDialog(
                                            context,
                                            true,
                                            'Cargando...',
                                            null,
                                            Colors.blue);
                                        res =
                                            await ServicioPublicacionesMasivas()
                                                .updatePublicacionMasiva(
                                                    data[index]['pu_cdgo']
                                                        .toString(),
                                                    '1');
                                        if (res) {
                                          Navigator.pop(context);
                                          WidgetsGenericos.showLoaderDialog(
                                              context,
                                              false,
                                              'Publicacion rechazada',
                                              Icons.check_circle_outlined,
                                              Colors.green);
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          Navigator.pop(context);
                                          res = false;
                                        } else {
                                          Navigator.pop(context);
                                          WidgetsGenericos.showLoaderDialog(
                                              context,
                                              false,
                                              'Ha ocurrido un error',
                                              Icons.error_outline,
                                              Colors.red);
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          Navigator.pop(context);
                                        }
                                      },
                                      color: Colors.blue,
                                      icon: Icon(Icons.reply_rounded),
                                      text: 'Rechazar',
                                    )),
                                    Expanded(
                                        child: GFButton(
                                      onPressed: () async {
                                        WidgetsGenericos.showLoaderDialog(
                                            context,
                                            true,
                                            'Cargando...',
                                            null,
                                            Colors.blue);
                                        res =
                                            await ServicioPublicacionesMasivas()
                                                .updatePublicacionMasiva(
                                                    data[index]['pu_cdgo']
                                                        .toString(),
                                                    '2');
                                        if (res) {
                                          Navigator.pop(context);
                                          WidgetsGenericos.showLoaderDialog(
                                              context,
                                              false,
                                              'Publicacion aceptada',
                                              Icons.check_circle_outlined,
                                              Colors.green);
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          Navigator.pop(context);
                                          res = false;
                                        } else {
                                          Navigator.pop(context);
                                          WidgetsGenericos.showLoaderDialog(
                                              context,
                                              false,
                                              'Ha ocurrido un error',
                                              Icons.error_outline,
                                              Colors.red);
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          Navigator.pop(context);
                                        }
                                      },
                                      color: Colors.green,
                                      icon: Icon(Icons.share),
                                      text: 'Aprobar',
                                    ))
                                  ],
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  );
                  // ListTile(
                  //   title: Text('${listaPqrs[index]['pqrs_asunto']}'),
                  // );
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
  }
}
