import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioVehiculos {
  String url = Url().getUrl();

  Future<dynamic> getVehiculos() async {
    try {
      final response = await http.get(
        url + 'vehiculo',
        headers: {'x-access-token': App.localStorage.getString('token')},
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        Hive.box('vehiculosdb')
            .put('data', (jsonResponse['status']) ? jsonResponse['data'] : []);
      }
      final pqrs = Hive.box('vehiculosdb').get('data');
      return pqrs;
    } catch (e) {}
  }

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

  Future<dynamic> searchVehiculo(String ve_cdgo) async {
    var response;
    try {
      response = await http.get(
        url + "vehiculo/" + ve_cdgo,
        headers: {
          "x-access-token": App.localStorage.getString('token'),
        },
      ).timeout(Duration(seconds: 40));
    } on Error catch (e) {
      print('Error: $e');
    }

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'];
      print(jsonResponse);
      return jsonResponse;
    } else {
      return null;
    }
  }
}
