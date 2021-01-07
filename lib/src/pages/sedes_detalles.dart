import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/sedes.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';

class page_sedes_detalles extends StatefulWidget {
  final String data;
  page_sedes_detalles(this.data, {Key key}) : super(key: key);

  @override
  _page_sedes_detallesState createState() => _page_sedes_detallesState();
}

class _page_sedes_detallesState extends State<page_sedes_detalles> {
  Future<Sede> searchSede;
  Sede sede;
  String id;
  @override
  void initState() {
    searchSede = ServicioSede().searchSede(widget.data);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sede'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.edit_outlined),
            iconSize: 30,
            tooltip: 'Editar',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => pageSedes('Editar', id, sede),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Sede>(
              future: searchSede,
              builder: (context, snapshot) {
                sede = snapshot.data;
                if (snapshot.hasData)
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _imagen_fondo(screen, snapshot.data.sd_jersey),
                            Column(
                              children: [
                                SizedBox(
                                  height: screen.height / 3.0,
                                ),
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.vertical(
                                          top: Radius.circular(70))),
                                  child: Text(''),
                                ),
                                Container(
                                  color: Colors.white,
                                  // padding: EdgeInsets.only(top: 80),

                                  child: Column(
                                    children: [
                                      // Texto Nombre Sede
                                      nombre_sede(snapshot.data.sd_desc,
                                          snapshot.data.cd_desc)
                                      // -----------------
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SafeArea(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screen.height / 4.2,
                                    ),
                                    _imagen_perfil(snapshot.data.sd_logo),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Mesa de trabajo:',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        future_mesa(searchSede),
                      ],
                    ),
                  );
                else if (snapshot.hasError) return Text(snapshot.error);
                return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text('Cargando informacion')
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget future_mesa(Future<Sede> searchSede) {
  return SingleChildScrollView(
    child: FutureBuilder<Sede>(
      future: searchSede,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Sede data = snapshot.data;
          return lista_mesa(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    ),
  );
}

Widget lista_mesa(Sede sede) {
  if (sede.mesas.length > 0) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sede.mesas.length,
      itemBuilder: (context, index) {
        if (sede.mesas != null) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black26, width: 0.5),
              ),
            ),
            child: ListTile(
              leading: Icon(Icons.verified_user),
              title: Text(
                '${sede.mesas[index].us_nombres}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  '${sede.mesas[index].us_alias}   -${sede.mesas[index].ca_desc}-'),
            ),
          );
        } else {
          return Container(
              child: ListTile(
            title: Text('vacio'),
          ));
        }
      },
    );
  } else {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
          child: Center(
        child: Text(
          'No se han agregado integrantes a la mesa de trabajo',
          style: TextStyle(color: Colors.black26),
        ),
      )),
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
        border: Border.all(color: Colors.white, width: 5.0),
      ),
    ),
  );
}

Widget _imagen_fondo(Size screen, String url) {
  return Container(
    height: screen.height / 2.6,
    child: FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: url,
      fit: BoxFit.cover,

      //   // En esta propiedad colocamos el alto de nuestra imagen
      width: double.infinity,
    ),
    decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: NetworkImage(url),
        //   fit: BoxFit.cover,
        // ),
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

Widget nombre_sede(String nombre, String ciudad) {
  return Center(
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text(
            nombre,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text('Ciudad: ' + ciudad)
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black26, width: 2.0),
        ),
      ),
    ),
  );
}
