import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ui_flutter/src/models/model_sede.dart';
import 'package:ui_flutter/src/pages/sedes_detalles.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/services/socket.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class cont_inicio extends StatefulWidget {
  cont_inicio({Key key}) : super(key: key);

  @override
  _cont_inicioState createState() => _cont_inicioState();
}

class _cont_inicioState extends State<cont_inicio> {
  int currentPos = 0;

  Future<dynamic> lista = ServicioSede().cargarSedes(true);
  SedesList sedelist;
  SocketIO socket;
  @override
  void initState() {
    sockets();
    super.initState();
  }

  sockets() async {
    socket = await socketRes().conexion();
    print('hola socket');
    socket.connect();
    socket.on('sedesres', (_) {
      print('sedes');
    });
  }

  void cargalist() async {
    sedelist = await lista;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      shrinkWrap: true,
      children: [
        res_carousel(lista),
        listado(),
      ],
    ));
  }

  Widget res_carousel(Future<dynamic> lista) {
    return Container(
      child: FutureBuilder(
        future: ServicioSede().cargarSedes(false),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              if (snapshot.hasError) {
                return Text("${snapshot.error} error .");
              } else {
                return Center(
                  child: Text('conecction.none'),
                );
              }

              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                // SedesList data = snapshot.data;

                // return carousel(data);
                return Center(
                  child: Text('Hola mundo'),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Container(
                  color: Colors.grey,
                  child: Text(''),
                );
              }

              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());

              break;
            case ConnectionState.active:
              return Center(
                child: Text('conecction.Active'),
              );

              break;
          }
        },
      ),
    );
  }

  Widget carousel(List data) {
    return Container(
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 7,
              autoPlayCurve: Curves.easeInBack,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    currentPos = index;
                  },
                );
              },
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return cont_carousel(data, index);
            },
          ),
        ],
      ),
    );
  }

  Widget cont_carousel(List data, int index) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          color: Colors.white,
          child: Image.network(
            data[index]['sd_jersey'],
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(20, 0, 0, 0)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  data[index]['sd_desc'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listado() {
    return ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Column(
                children: [
                  titulo_lista('Convenios'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return WidgetsGenericos.itemList(
                          'imagen ${index}',
                          null,
                          'https://picsum.photos/200',
                          context,
                          page_sedes_detalles('110', 'Buenaventura'));
                    },
                  ),
                  Divider(),
                  Column(children: [
                    titulo_lista('Convenios'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return WidgetsGenericos.itemList(
                            'imagen ${index}',
                            null,
                            'https://picsum.photos/200',
                            context,
                            page_sedes_detalles('110', 'Buenaventura'));
                      },
                    ),
                  ])
                ],
              ),
            ],
          )
        ]);
  }

  Widget titulo_lista(String titulo) {
    return Container(
      width: double.infinity,
      color: Colors.grey,
      child: Center(
          child: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}
