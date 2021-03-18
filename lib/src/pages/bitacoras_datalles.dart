import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:ui_flutter/src/services/services_sedes.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

class PagesBitacoraDetalles extends StatefulWidget {
  dynamic bitacora;
  PagesBitacoraDetalles(this.bitacora, {Key key}) : super(key: key);

  @override
  _PagesBitacoraDetallesState createState() => _PagesBitacoraDetallesState();
}

class _PagesBitacoraDetallesState extends State<PagesBitacoraDetalles> {
  int currentPos = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('data'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              carousel(widget.bitacora['bi_img']),
              Divider(),
              titulo(widget.bitacora),
              usuario(widget.bitacora),
              descripcion(widget.bitacora),
              comentarios(widget.bitacora)
            ],
          ),
        ));
  }

  Widget titulo(data) {
    return Container(
      child: Column(
        children: [
          Text(
            data['bi_lugar'],
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(data['bi_ciudad']),
        ],
      ),
    );
  }

  Widget usuario(data) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Usuario'),
                  ],
                ),
                Text(
                  data['us_alias'],
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
// -----------------------------------------------
          Container(
            child: Column(
              children: [
                Text('Sede'),
                Text(
                  data['sd_desc'],
                  style: Theme.of(context).textTheme.title,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget descripcion(data) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(15),
      // width: double.infinity,
      constraints: BoxConstraints(minHeight: 50, minWidth: double.infinity),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.black26, width: 0.5),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(data['bi_desc']),
          )
        ],
      ),
    );
  }

  Widget comentarios(data) {
    return Container(
      margin: EdgeInsets.all(15),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            child: Text('Comentarios(0)'),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 0.5),
            ),
            child: ListTile(
              title: TextFormField(
                autofocus: false,
                // controller: descTextController,
                maxLength: 1000,
                // maxLines: 2,
                decoration: new InputDecoration(
                  labelText: 'Comentar',
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  // hintText: 'Describe el evento(lugar, hora, informacion, etc)',
                ),
              ),
              trailing: GFIconButton(
                size: GFSize.SMALL,
                icon: Icon(
                  Icons.send_rounded,
                ),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget carousel(data) {
    print(data[0]['imbi_img']);
    return Container(
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 10 / 9,
              autoPlayCurve: Curves.easeInBack,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.99,
              // onPageChanged: (index, reason) {
              //   setState(
              //     () {
              //       currentPos = index;
              //     },
              //   );
              // },
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

  Widget cont_carousel(data, int index) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          width: double.infinity,
          height: 400,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              WidgetsGenericos.fullDialogImage(data[index]['imbi_img']);
            },
            child: Image.network(
              data[index]['imbi_img'],
              height: 500,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Positioned(
        //   bottom: 0.0,
        //   left: 0.0,
        //   right: 0.0,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           Color.fromARGB(200, 0, 0, 0),
        //           Color.fromARGB(20, 0, 0, 0)
        //         ],
        //         begin: Alignment.bottomCenter,
        //         end: Alignment.topCenter,
        //       ),
        //     ),
        //     padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        //     child: Column(
        //       children: [
        //         Text(
        //           data[index]['sd_desc'],
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 20.0,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
