import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/pages/bitacoras_datalles.dart';
import 'package:ui_flutter/src/services/services_bitacora.dart';
import 'package:ui_flutter/src/services/socket.dart';
import 'package:ui_flutter/src/widgets/nav_bar/nav_drawer.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'bitacora_personal.dart';

class pages_listas_bitacoras extends StatefulWidget {
  pages_listas_bitacoras({Key key}) : super(key: key);

  @override
  _pages_listas_bitacorasState createState() => _pages_listas_bitacorasState();
}

class _pages_listas_bitacorasState extends State<pages_listas_bitacoras> {
  Future<dynamic> bitacoras = ServicioBitacoras().getBitacora(false);

  List bitlist = Hive.box('bitacorasdb').get('data', defaultValue: []);
  int us_perfil = App.localStorage.getInt('us_perfil');

  // el metodo socket crea una conexion con el servidor de sockets y escucha el
// evento sedeempresas para hacer cambios en tiempo real
  socket() async {
    SocketIO socket = await ServicioSocket().conexion();
    socket.on('empresasres', (_) async {
      bitlist = await ServicioBitacoras().getBitacora(true);
      if (mounted) {
        setState(() {
          bitlist = bitlist;
        });
      }
    });
  }

// el metodo cargar() carga la base de datos local en el caso de que esta se encuentre vacia
  cargar() async {
    if (!bitlist.isNotEmpty) {
      bitlist = await await ServicioBitacoras().getBitacora(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Nav_drawer(),
      appBar: AppBar(
        title: Text('Bitacoras'),
      ),
      floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
          context, PagesBitacoraPersonal()),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: bitacoras,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return listaBitacoras(bitlist);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget listaBitacoras(data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        var lista_bitacoras = data[index];
        return cards(lista_bitacoras);
      },
    );
  }

  Widget cards(data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PagesBitacoraDetalles(data)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.only(bottom: 5),
          shadowColor: Colors.black,

          semanticContainer: true,
          color: Colors.grey[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          // borderOnForeground: true,
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1.0),
            ),
            padding: EdgeInsets.all(1),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 50,
                  ),
                  title: Row(
                    children: [
                      Text(data['us_alias']),
                      Text(' (' + data['sd_desc'] + ')',
                          style: Theme.of(context).textTheme.caption)
                    ],
                  ),
                  subtitle: Text(
                    data['fecha'].toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
                Image(
                  image: NetworkImage(
                    data['bi_img'][0]['imbi_img'],
                  ),
                  fit: BoxFit.cover,
                  height: 200.0,
                  width: double.infinity,
                ),
                ListTile(
                  title: Text(
                    data['bi_lugar'],
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(data['bi_ciudad']),
                  // trailing: Container(
                  //   child: Text(
                  //     '120 comentarios',
                  //     style: Theme.of(context).textTheme.subtitle2,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
