import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:shimmer/shimmer.dart';

class WidgetsGenericos {
  static showLoaderDialog(BuildContext context, bool estado, String texto,
      IconData icon, Color color) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          estado ? CircularProgressIndicator() : Text(''),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Row(
                children: [
                  Icon(icon, color: color),
                  Container(
                    child: Text(
                      '  ' + texto,
                      style: TextStyle(color: color),
                    ),
                  )
                ],
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

  static Widget shimmerList() {
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
  static Widget itemList(String title, String subtitles, String url,
      BuildContext context, Widget pagina) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => pagina),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.black12, width: 0.7),
            )),
            child: ListTile(
              //minVerticalPadding: 10,
              leading: url != null
                  ? Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    WidgetsGenericos.fullDialogImage(url),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: loadImage(url),
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
                    ),
              title: Text(title),
              subtitle: subtitles == null ? null : Text(subtitles),
              trailing: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(Icons.navigate_next)),
            ),
          )),
    );
  }

// _______________________________________________________________

  static Widget containerErrorConection(BuildContext context, Widget pagina) {
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

  static Widget containerEmptyData(BuildContext context) {
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

  static Widget floatingButtonRegistrar(BuildContext context, Widget pagina) {
    return FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pagina),
      ),
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(Icons.add, size: 35.0, color: Colors.white),
    );
  }

  static formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: item,
        ),
      ),
    );
  }

  static loadImage(String url) {
    try {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        placeholder: (context, url) => Center(
          child: Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.grey[300],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 50,
                height: 50,
                child: Text(''),
              )),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } catch (e) {
      print('e');
      return Container(
        child: Text('axx'),
      );
    }
  }

  static fullDialogImage(String url) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Imagen'),
      ),
      body: SizedBox.expand(
        child: Container(
          color: Colors.black,
          child: InteractiveViewer(
              child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading_img.gif',
            image: url,
            // fit: BoxFit.cover,

            //   // En esta propiedad colocamos el alto de nuestra imagen
            width: double.infinity,
          )),
        ),
      ),
    );
  }
}
