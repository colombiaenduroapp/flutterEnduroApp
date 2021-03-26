import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioPQRS {
  String url = Url().getUrl();

  Future<dynamic> getPQRS() async {
    try {
      final response = await http.get(
        url + 'pqrs',
        headers: {'x-access-token': App.localStorage.getString('token')},
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final pqrsvieja = (Hive.box('pqrsdb').get('data') == null)
            ? []
            : Hive.box('pqrsdb').get('data');
        if (pqrsvieja.length < jsonResponse['data'].length) {
          final dif = jsonResponse['data'].length - pqrsvieja.length;
          App.localStorage.setInt('cambio_pqrs', dif);
        }
        Hive.box('pqrsdb')
            .put('data', (jsonResponse['status']) ? jsonResponse['data'] : []);
      }

      final pqrs = Hive.box('pqrsdb').get('data');
      print(pqrs);
      return pqrs;
    } catch (e) {}
  }

  Future<bool> addPQRS(String pqrsAsunto, String pqrsDesc) async {
    try {
      final response = await http.post(
        url + 'pqrs',
        headers: {'x-access-token': App.localStorage.getString('token')},
        body: {'pqrs_asunto': pqrsAsunto, 'pqrs_desc': pqrsDesc},
      ).timeout(Duration(seconds: 15));
      return (response.statusCode == 200) ? true : false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
