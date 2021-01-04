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
                            margin: EdgeInsets.only(bottom: 10),
                            color: Colors.grey[300],
                            width: double.infinity,
                            height: 250,
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
          color: Colors.orange[50],
          // color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          borderOnForeground: true,
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(data.eventos[index].ev_img),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListTile(
                        tileColor: Colors.white70,
                        leading: Icon(Icons.event_available_outlined),
                        title: Text(
                          data.eventos[index].ev_desc,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Organiza: ' + data.eventos[index].sd_desc,
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.white70,
                          child: Icon(Icons.favorite_border_outlined),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha: ' + data.eventos[index].ev_fecha_inicio,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Text('Dias faltantes'),
                          Text(data.eventos[index].ev_faltante.toString())
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
