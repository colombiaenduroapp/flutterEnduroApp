import 'package:flutter/material.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';

class page_sedes_detalles extends StatefulWidget {
  final String data;
  page_sedes_detalles(this.data, {Key key}) : super(key: key);

  @override
  _page_sedes_detallesState createState() => _page_sedes_detallesState();
}

class _page_sedes_detallesState extends State<page_sedes_detalles> {
  Future<Sede> searchSede;
  @override
  void initState() {
    searchSede = ServicioCiudad().searchSede(widget.data);
    print(searchSede);
    print(widget.data);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sede'),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<Sede>(
              future: searchSede,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:
                              Image(image: NetworkImage(snapshot.data.sd_logo)),
                        ),
                        height: 200,
                        width: 500,
                      ),
                      Text(snapshot.data.sd_desc),
                      Text(snapshot.data.sd_estado),
                    ],
                  );
                else if (snapshot.hasError) return Text(snapshot.error);
                return Text("Await for data");
              },
            ),
            Text(widget.data),
          ],
        ),
      ),
    );
  }
}
