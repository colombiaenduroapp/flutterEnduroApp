import 'dart:convert';

import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioVehiculos {
  String url = Url().getUrl();

  // Future<dynamic> getPQRS() async {
  //   try {
  //     final response = await http.get(
  //       url + 'pqrs',
  //       headers: {'x-access-token': App.localStorage.getString('token')},
  //     ).timeout(Duration(seconds: 15));

  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       final pqrsvieja = (Hive.box('pqrsdb').get('data') == null)
  //           ? []
  //           : Hive.box('pqrsdb').get('data');
  //       if (pqrsvieja.length < jsonResponse['data'].length) {
  //         final dif = jsonResponse['data'].length - pqrsvieja.length;
  //         App.localStorage.setInt('cambio_pqrs', dif);
  //       }
  //       Hive.box('pqrsdb')
  //           .put('data', (jsonResponse['status']) ? jsonResponse['data'] : []);
  //     }
  //     final pqrs = Hive.box('pqrsdb').get('data');
  //     return pqrs;
  //   } catch (e) {}
  // }

  Future<bool> addVehiculos(
      String ve_placa,
      String ve_desc,
      DateTime ve_fecha_soat,
      String ve_foto_soat,
      DateTime ve_fecha_tecno,
      String ve_foto_tecno) async {
    var response;
    try {
      response = await http.post(
        url + 'vehiculo',
        headers: {'x-access-token': App.localStorage.getString('token')},
        body: {
          've_placa': ve_placa,
          've_desc': ve_desc,
          've_fecha_soat': ve_fecha_soat.toString() ?? '',
          've_foto_soat': ve_foto_soat ?? '',
          've_fecha_tecno': ve_fecha_tecno.toString() ?? '',
          've_foto_tecno': ve_foto_tecno ?? ''
        },
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        print(json.decode(response.body));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
