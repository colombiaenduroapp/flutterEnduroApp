import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
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
                CircularProgressIndicator(),
                Text('Cargando Eventos...'),
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
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
              .withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.event_available_outlined),
                      title: Text(
                        data.eventos[index].ev_desc,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Organiza: ' + data.eventos[index].sd_desc,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.favorite_border_outlined),
                      ),
                    ],
                  )
                ],
              ),
              FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: data.eventos[index].ev_img,
                fit: BoxFit.cover,

                //   // En esta propiedad colocamos el alto de nuestra imagen
                width: double.infinity,
                height: 150,
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
      );
    },
  );
}
