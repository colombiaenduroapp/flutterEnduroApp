import 'package:flutter/material.dart';
import 'package:ui_flutter/src/services/sev_sedes.dart';

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
          return _tile(data[index]['sd_desc'],
              data[index]['sd_cdgo'].toString(), Icons.work);
        });
  }

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      leading: Image(
          image: NetworkImage(
              'https://www.flaticon.es/svg/static/icons/svg/27/27176.svg')));
}
