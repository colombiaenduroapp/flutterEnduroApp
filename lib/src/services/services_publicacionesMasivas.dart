import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioPublicacionesMasivas {
  String url = Url().getUrl();

  Future<dynamic> getPublicacionesMasivas() async {
    final publicacionesvieja =
        Hive.box('publicacionesmasivasdb').get('data') ?? [];
    try {
      final response = await http.get(
        url + 'publicacion_masiva',
        headers: {'x-access-token': App.localStorage.getString('token')},
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final dif = jsonResponse['data'].length - publicacionesvieja.length;
        if (publicacionesvieja.length < jsonResponse.length)
          App.localStorage.setInt('cambio_publicacionesmasivas', dif);
        Hive.box('publicacionesmasivasdb')
            .put('data', (jsonResponse['status']) ? jsonResponse['data'] : []);
        final responses = Hive.box('publicacionesmasivasdb').get('data');
        return responses;
      }
    } catch (e) {}
  }

  Future<bool> addPublicacionMasiva(String pu_desc, String pu_link) async {
    try {
      final response = await http.post(
        url + 'publicacion_masiva',
        headers: {'x-access-token': App.localStorage.getString('token')},
        body: {'pu_desc': pu_desc, 'pu_link': pu_link},
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        App.conexion.emit('publicacionesmasivas', [
          {'tipo': 'registro', 'publicacionesmasivas': ''}
        ]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePublicacionMasiva(String puCdgo, String epCdgo) async {
    try {
      print(puCdgo);
      final response = await http.put(
        url + 'publicacion_masiva/' + puCdgo,
        headers: {'x-access-token': App.localStorage.getString('token')},
        body: {
          'pu_estado_publicacion_ep_cdgo': epCdgo,
        },
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
