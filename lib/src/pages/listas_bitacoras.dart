import 'package:flutter/material.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'bitacora_personal.dart';

class pages_listas_bitacoras extends StatefulWidget {
  pages_listas_bitacoras({Key key}) : super(key: key);

  @override
  _pages_listas_bitacorasState createState() => _pages_listas_bitacorasState();
}

class _pages_listas_bitacorasState extends State<pages_listas_bitacoras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hola'),
      ),
      floatingActionButton: WidgetsGenericos.floatingButtonRegistrar(
          context, PagesBitacoraPersonal()),
      body: SingleChildScrollView(
        child: Container(
          // decoration: Box,

          child: Column(
            children: [
              cards('assets/error1.png'),
              cards('assets/empty_data11.png'),
              cards('assets/fondo_login.jpg'),
              cards('assets/icons/descarga32.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget cards(String asset) {
    return Container(
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                image: AssetImage(
                  asset,
                ),
                fit: BoxFit.cover,
                height: 200.0,
                width: double.infinity,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Text(
              //     'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
              //     style: TextStyle(color: Colors.black.withOpacity(0.6)),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Lago Calima, Darien',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Container(
                      child: Text(
                        '120 comentarios',
                        style: Theme.of(context).textTheme.subtitle2,
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
  }
}
