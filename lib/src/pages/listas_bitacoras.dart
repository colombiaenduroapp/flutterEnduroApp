import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/bitacoras_datalles.dart';
import 'package:ui_flutter/src/services/services_bitacora.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'bitacora_personal.dart';

class pages_listas_bitacoras extends StatefulWidget {
  pages_listas_bitacoras({Key key}) : super(key: key);

  @override
  _pages_listas_bitacorasState createState() => _pages_listas_bitacorasState();
}

class _pages_listas_bitacorasState extends State<pages_listas_bitacoras> {
  Future<dynamic> bitacoras;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarBitacoras();
  }

  cargarBitacoras() async {
    bitacoras = ServicioBitacoras().getBitacora(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hola'),
      ),
      floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
          context, PagesBitacoraPersonal()),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: bitacoras,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return listaBitacoras(snapshot.data);
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
        margin: EdgeInsets.only(bottom: 5),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black26, width: 0.5),
        // ),
        child: Card(
          elevation: 20,
          margin: EdgeInsets.all(5),
          shadowColor: Colors.black26,
          // semanticContainer: true,
          color: Colors.grey[300],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          // borderOnForeground: true,
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 0.5)),
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 50,
                  ),
                  title: const Text('Juanito Perez'),
                  subtitle: Text(
                    'hace 5 minutos',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
                  trailing: Container(
                    child: Text(
                      '120 comentarios',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
