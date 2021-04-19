import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_flutter/src/models/model_usuario.dart';
import 'package:ui_flutter/src/services/services_usuario.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PageListasSolicitudUsuarios extends StatefulWidget {
  PageListasSolicitudUsuarios({Key key}) : super(key: key);

  @override
  _PageListasSolicitudUsuariosState createState() =>
      _PageListasSolicitudUsuariosState();
}

class _PageListasSolicitudUsuariosState
    extends State<PageListasSolicitudUsuarios> {
  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text('Solicitudes de usuarios');
  Icon _searchIcon = Icon(Icons.search);
  String _searchText;
  List<dynamic> usuarios = Hive.box('solicitudusuariosdb').get('data');

  _PageListasSolicitudUsuariosState() {
    _filter.addListener(() {
      setState(() {
        _searchText = (_filter.text.isEmpty) ? "" : _filter.text;
      });
    });
  }

  @override
  void initState() {
    print(usuarios);
    _searchText = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: [
          IconButton(icon: _searchIcon, onPressed: _searchPressed),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _jobListView(usuarios),
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
        this._appBarTitle = new Text('Solicitudes de usuarios');
        _filter.clear();
      }
    });
  }

  Widget _jobListView(data) {
    if (data.length > 0) {
      List<dynamic> listaUsuarios = (_searchText.isNotEmpty)
          ? usuarios
              .where((f) => f['us_nombres']
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()))
              .toList()
          : data;
      return SingleChildScrollView(
        child: Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listaUsuarios.length,
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
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (listaUsuarios[index]['us_logo'] != null)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right: 10, left: 10, top: 10),
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  WidgetsGenericos
                                                      .fullDialogImage(
                                                          listaUsuarios[index]
                                                              ['us_logo']),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: listaUsuarios[index]
                                              ['us_logo'],
                                          placeholder: (context, url) => Center(
                                            child: Shimmer.fromColors(
                                              baseColor: Colors.grey[400],
                                              highlightColor: Colors.grey[300],
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                width: 50,
                                                height: 50,
                                                child: Text(''),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      right: 10, left: 10, top: 10),
                                  child: Container(
                                    child: Icon(Icons.business_outlined),
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listaUsuarios[index]['us_nombres'] +
                                    ' ' +
                                    listaUsuarios[index]['us_apellidos'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                listaUsuarios[index]['us_sede'],
                                style:
                                    TextStyle(color: Colors.blueGrey.shade300),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            boton("Aceptar", listaUsuarios[index]['us_cdgo']),
                            boton("Eliminar", listaUsuarios[index]['us_cdgo']),
                          ],
                        ),
                      )
                    ],
                  ));
            },
          ),
        ),
      );
    } else {
      return Center(child: WidgetsGenericos.containerEmptyData(context));
    }
  }

  boton(String nombreBoton, int us_cdgo) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: GFButton(
          child: Text(nombreBoton),
          color: (nombreBoton == "Aceptar")
              ? Colors.blue
              : Colors.blueGrey.shade200,
          onPressed: () async {
            bool res = false;
            WidgetsGenericos.showLoaderDialog(
                context, true, 'Cargando...', null, Colors.blue);

            res = await ServicioUsuario()
                .updateEstado(us_cdgo.toString(), nombreBoton);
            if (res) {
              usuarios = await ServicioUsuario().getSolicitudUsuarios();
              if (mounted) {
                setState(() {
                  usuarios = usuarios;
                });
              }
              Navigator.pop(context);
              WidgetsGenericos.showLoaderDialog(
                  context,
                  false,
                  (nombreBoton == "Aceptar")
                      ? 'Aceptado Exitosamente'
                      : "Solicitud Eliminada",
                  Icons.check_circle_outlined,
                  Colors.green);
              await Future.delayed(Duration(milliseconds: 1000));
              Navigator.pop(context);
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
