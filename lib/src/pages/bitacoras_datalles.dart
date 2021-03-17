import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
              titulo(widget.bitacora)
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
            style: Theme.of(context).textTheme.title,
          ),
          Text(data['bi_ciudad']),
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
              viewportFraction: 0.8,
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
