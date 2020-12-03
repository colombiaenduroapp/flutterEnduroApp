import 'package:flutter/material.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';

class cont_eventos extends StatefulWidget {
  cont_eventos({Key key}) : super(key: key);

  @override
  _cont_eventosState createState() => _cont_eventosState();
}

class _cont_eventosState extends State<cont_eventos> {
  Future<SedesList> lista;
  @override
  void initState() {
    lista = ServicioCiudad().cargarSedes();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<SedesList>(
      future: lista,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SedesList data = snapshot.data;
          return listaa(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        // return Text(snapshot.data.sedes.toString());
      },
    ));
  }
}

Widget listaa(SedesList data) {
  return ListView.builder(
    itemCount: data.sedes.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(data.sedes[index].sd_desc),
      );
    },
  );
}
