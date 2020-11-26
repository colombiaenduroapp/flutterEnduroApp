import 'package:flutter/material.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';
import 'dart:convert';
import 'dart:typed_data';

class cont_sedes extends StatefulWidget {
  cont_sedes({Key key}) : super(key: key);

  @override
  _cont_sedesState createState() => _cont_sedesState();
}

class _cont_sedesState extends State<cont_sedes> {
  Future<List> lista = ServicioCiudad().getCiudad();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: lista,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data;
          // print('object ${data}');
          return _jobsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Uint8List _bytesImage =
              Base64Decoder().convert(data[index]['sd_logo']);
          return _tile(data[index]['sd_desc'],
              data[index]['sd_cdgo'].toString(), _bytesImage);
        });
  }

  Widget _tile(String title, String subtitle, Uint8List _bytesImage) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0)),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: MemoryImage(_bytesImage),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                    // icon edit
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.deepOrangeAccent,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ListTile(
  //       title: Text(title,
  //           style: TextStyle(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 20,
  //           )),
  //       subtitle: Text(subtitle),
  //       leading: Icon(
  //         icon,
  //         color: Colors.blue[500],
  //       ),
  //     );
}
