import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/empresas_detalles.dart';
import 'package:ui_flutter/src/services/services_empresa.dart';

import 'empresas.dart';

class pages_listas_empresas extends StatefulWidget {
  pages_listas_empresas({Key key}) : super(key: key);

  @override
  _pages_listas_empresasState createState() => _pages_listas_empresasState();
}

class _pages_listas_empresasState extends State<pages_listas_empresas> {
  Future<EmpresaList> lista = ServicioEmpresa().getEmpresa();
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        appBar: AppBar(
          title: Text('Empresa'),
        ),
        body: FutureBuilder<EmpresaList>(
          future: lista,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                if (snapshot.hasError) {
                  return Text("${snapshot.error} error            .");
                } else {
                  return Center(
                    child: Text('conecction.none'),
                  );
                }

                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  EmpresaList data = snapshot.data;
                  return _jobsListView(data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return Center(
                    child: Text(
                        'Tu conexion es inestable o ha ocurrido un problema en el servidor. Si el problema persiste comunicate con los desarrolladores'),
                  );
                }

                break;
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cargando...',
                        style: TextStyle(fontSize: 30, color: Colors.black45),
                      ),
                      Image(image: AssetImage('assets/loading.gif')),
                    ],
                  ),
                );

                break;
              case ConnectionState.active:
                return Center(
                  child: Text('conecction.Active'),
                );

                break;
              default:
            }
          },
        ),
        floatingActionButton: floating_button(),
      );
    } catch (exception) {
      print(exception);
      return Center(
        child:
            Text('Ha ocurrido un error de conexion o No hay datos por mostrar'),
      );
    }
  }

  Widget _jobsListView(data) {
    try {
      if (data.empresas.length > 0) {
        return ListView.builder(
            itemCount: data.empresas.length,
            itemBuilder: (context, index) {
              return _tile(
                  data.empresas[index].em_nombre,
                  data.empresas[index].em_cdgo.toString(),
                  data.empresas[index].em_logo);
            });
      } else {
        return Container(
          child: Center(
            child: Text(
              'No hay sedes registradas',
              style: TextStyle(color: Colors.black26),
            ),
          ),
        );
      }
    } catch (e) {}
  }

  floating_button() {
    return FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => pagesEmpresa(null, null, 'Registrar')),
      ),
      backgroundColor: Colors.redAccent,
      child: Icon(
        Icons.add,
        size: 35.0,
      ),
    );
  }

// Widget item list contiene todo los atributos de un list item
  Widget _tile(String title, String subtitle, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pages_empresas_detalles(subtitle),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1.0)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Logo Sede

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: _logo_title(url),
                          ),
                          // Nombre Sede
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      // icon next
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [Icon(Icons.navigate_next)],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _logo_title(String url) {
    try {
      return url != null
          ? Container(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                // image: url,
                image: url,
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Icon(Icons.image_not_supported_rounded);
                },
                fit: BoxFit.cover,

                //   // En esta propiedad colocamos el alto de nuestra imagen
                width: double.infinity,
                height: 50,
              ),
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
              ),
            )
          : Container(
              child: Icon(Icons.business_outlined),
              width: 50,
              height: 50,
            );
    } on NetworkImageLoadException catch (e) {
      print('hola');
      return Container(child: Text(e.toString()));
    }
  }
}
