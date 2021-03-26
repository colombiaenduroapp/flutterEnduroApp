import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioPQRS {
  String url = Url().getUrl();

  Future<dynamic> getPQRS() async {
    final pqrsvieja = Hive.box('pqrsdb').get('data');
    try {
      final response = await http.get(
        url + 'pqrs',
        headers: {'x-access-token': App.localStorage.getString('token')},
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final dif = jsonResponse.length - pqrsvieja.length;
        if (pqrsvieja.length < jsonResponse.length)
          App.localStorage.setInt('cambio_sede', dif);
        Hive.box('pqrsdb')
            .put('data', (jsonResponse['status']) ? jsonResponse['data'] : []);

        return jsonResponse['data'];
      }
    } catch (e) {}
  }

  Future<bool> addPQRS(String pqrsAsunto, String pqrsDesc) async {
    try {
      final response = await http.post(
        url + 'pqrs',
        headers: {'x-access-token': App.localStorage.getString('token')},
        body: {'pqrs_asunto': pqrsAsunto, 'pqrs_desc': pqrsDesc},
      ).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        App.conexion.emit('pqrs', [
          {'tipo': 'registro', 'pqrs': pqrsAsunto}
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
}
