import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_flutter/src/pages/eventos_detalles.dart';
import 'package:ui_flutter/src/services/services_eventos.dart';

class cont_eventos extends StatefulWidget {
  cont_eventos({Key key}) : super(key: key);

  @override
  _cont_eventosState createState() => _cont_eventosState();
}

class _cont_eventosState extends State<cont_eventos> {
  Future<EventosList> lista;

  @override
  void initState() {
    lista = ServicioEvento().getEventos();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<EventosList>(
      future: lista,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          EventosList data = snapshot.data;
          return listaa(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // if (snapshot.data == null) {
        //   return Center(
        //     child: Text('No hay eventos registrados'),
        //   );
        // }
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(10),
                            width: double.infinity,
                            height: 300,
                            child: Text(''),
                          ),
                          baseColor: Colors.grey[400],
                          highlightColor: Colors.grey[300],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}

Widget listaa(EventosList data) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: data.eventos.length,
    itemBuilder: (context, index) {
      return InkWell(
        splashColor: Colors.blueGrey,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  page_eventos_detalles(data.eventos[index].ev_cdgo),
            ),
          );
        },
        child: Card(
          color: Theme.of(context).primaryColor,
          // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          borderOnForeground: true,
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(data.eventos[index].ev_img),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(Icons.event_available_outlined,
                              color: Colors.white),
                          title: Text(
                            data.eventos[index].ev_desc,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            'Organiza: ' + data.eventos[index].sd_desc,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(10.0),
                    //       color: Colors.white70,
                    //       child: Icon(Icons.favorite_border_outlined),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        spreadRadius: 5,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha: ' + data.eventos[index].ev_fecha_inicio,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          children: [
                            Text('Dias faltantes',
                                style: (TextStyle(color: Colors.white))),
                            Text(
                              data.eventos[index].ev_faltante.toString(),
                              style: (TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
