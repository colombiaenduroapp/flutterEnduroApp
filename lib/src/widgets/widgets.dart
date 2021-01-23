import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_flutter/src/pages/inicio.dart';

class WidgetsGenericos {
  static Widget showLoaderDialog(
      BuildContext context, bool estado, String texto, IconData icon) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          estado ? CircularProgressIndicator() : Text(''),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Row(
                children: [Icon(icon), Text(texto)],
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Widget ShimmerList() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 14,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey[400],
                  highlightColor: Colors.grey[300],
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            width: double.infinity,
                            child: Text(''),
                          ),
                          leading: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 50,
                            height: 50,
                            child: Text(''),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ));
            },
          ),
        )
      ],
    );
  }

// ________________________________________________________________________________
  static Widget ItemList(
      String title, String url, BuildContext context, Widget pagina) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pagina),
          );
          timeDilation = 1.5;
        },
        child: Container(
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 0.7)),
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
                              child: url != null
                                  ? Container(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/loading.gif',
                                          // image: url,
                                          image: url,
                                          imageErrorBuilder:
                                              (BuildContext context,
                                                  Object exception,
                                                  StackTrace stackTrace) {
                                            return Icon(Icons
                                                .image_not_supported_rounded);
                                          },
                                          fit: BoxFit.cover,

                                          //   // En esta propiedad colocamos el alto de nuestra imagen
                                          width: double.infinity,
                                          height: 50,
                                        ),
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
                                    )),
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

// _______________________________________________________________

  static Widget ContainerErrorConection(BuildContext context, Widget pagina) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            child: Image(image: AssetImage('assets/error1.png')),
          ),
          Container(
            width: 300,
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              'Lo sentimos ha ocurrido un problema',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GFButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pagina),
              );
            },
            text: "Intentar nuevamente",
            icon: Icon(
              Icons.refresh_outlined,
              color: Theme.of(context).accentColor,
            ),
            shape: GFButtonShape.pills,
            type: GFButtonType.outline,
            size: GFSize.LARGE,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }

  static Widget ContainerEmptyData(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            child: Image(image: AssetImage('assets/empty_data11.png')),
          ),
          Container(
            width: 300,
            padding: EdgeInsets.only(bottom: 50),
            child: Text(
              'Oops!\n No hay datos para Mostrar',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // GFButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => pagina),
          //     );
          //   },
          //   text: "Intentar nuevamente",
          //   icon: Icon(
          //     Icons.refresh_outlined,
          //     color: Theme.of(context).accentColor,
          //   ),
          //   shape: GFButtonShape.pills,
          //   type: GFButtonType.outline,
          //   size: GFSize.LARGE,
          //   color: Theme.of(context).accentColor,
          // ),
        ],
      ),
    );
  }

  static Widget floating_button_registrar(BuildContext context, Widget pagina) {
    return FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pagina),
      ),
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(Icons.add, size: 35.0, color: Colors.white),
    );
  }
}
