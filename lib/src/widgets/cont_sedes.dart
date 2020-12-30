import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/pages/sedes_detalles.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';

class cont_sedes extends StatefulWidget {
  cont_sedes({Key key}) : super(key: key);

  @override
  _cont_sedesState createState() => _cont_sedesState();
}

class _cont_sedesState extends State<cont_sedes> {
  Future<SedesList> lista = ServicioSede().cargarSedes();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder<SedesList>(
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
                return _jobsListView(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Center(
                  child: Text(
                      'Tu conexion es inestable o ha ocurrido un problema en el servidor. Si el problema persiste comunicate con los desarrolladores'),
                );
              }

              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   'Cargando...',
                    //   style: TextStyle(fontSize: 30, color: Colors.black45),
                    // ),
                    Container(
                      width: 100,
                      child: Image(image: AssetImage('assets/loading.gif')),
                    )
                  ],
                ),
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
      );
    } catch (exception) {
      print(exception);
      return Center(
        child:
            Text('Ha ocurrido un error de conexion o No hay datos por mostrar'),
      );
    }
  }

  Widget _jobsListView(data) {
    try {
      if (data.sedes.length > 0) {
        return ListView.builder(
            itemCount: data.sedes.length,
            itemBuilder: (context, index) {
              return _tile(
                  data.sedes[index].sd_desc,
                  data.sedes[index].sd_cdgo.toString(),
                  data.sedes[index].sd_logo);
            });
      } else {
        return Container(
          child: Center(
            child: Text(
              'No hay sedes registradas',
              style: TextStyle(color: Colors.black26),
            ),
          ),
        );
      }
    } catch (e) {}
  }

// Widget item list contiene todo los atributos de un list item
  Widget _tile(String title, String subtitle, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => page_sedes_detalles(
                      subtitle,
                    )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1.0)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Logo Sede
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/loading.gif',
                                image: url,
                                fit: BoxFit.cover,

                                //   // En esta propiedad colocamos el alto de nuestra imagen
                                width: double.infinity,
                                height: 150,
                              ),
                              width: 50.0,
                              height: 50.0,
                              // decoration: new BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   image: new DecorationImage(
                              //     fit: BoxFit.fill,
                              //     image: NetworkImage(url),
                              //   ),
                              // ),
                            ),
                          ),
                          // Nombre Sede
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      // icon next
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Icon(Icons.navigate_next)],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
