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
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sede'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Sede>(
              future: searchSede,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Stack(
                    children: [
                      _imagen_fondo(screen, snapshot.data.sd_logo),
                      SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screen.height / 4.4,
                              ),
                              _imagen_perfil(snapshot.data.sd_logo),
                              // Texto Nombre Sede
                              Center(
                                child: Text(
                                  snapshot.data.sd_desc,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // -----------------
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                else if (snapshot.hasError) return Text(snapshot.error);
                return Text("Await for data");
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _imagen_perfil(String url) {
  return Center(
    child: Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(color: Colors.white, width: 5.0)),
    ),
  );
}

Widget _imagen_fondo(Size screen, String url) {
  return Container(
    height: screen.height / 2.6,
    decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
  );
}
