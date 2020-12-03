import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/pages/sedes_detalles.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';

class cont_sedes extends StatefulWidget {
  cont_sedes({Key key}) : super(key: key);

  @override
  _cont_sedesState createState() => _cont_sedesState();
}

class _cont_sedesState extends State<cont_sedes> {
  Future<List> lista = ServicioCiudad().getCiudad();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder<List>(
        future: lista,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return _jobsListView(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
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

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index]['sd_desc'],
              data[index]['sd_cdgo'].toString(), data[index]['sd_logo']);
        });
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
                                width: 50.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(url),
                                    ))),
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
