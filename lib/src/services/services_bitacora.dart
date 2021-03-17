import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:ui_flutter/src/services/service_url.dart';

class ServicioBitacoras {
  String url = Url().getUrl();

  Future<dynamic> getBitacora(bool cambio) async {
    var jsonResponse;
    http.Response response;
    try {
      // final empresas = Hive.box('empresasdb').get('data', defaultValue: []);
      // if (!cambio) {
      //   if (empresas.isNotEmpty) {
      //     return empresas;
      //   }
      // }
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.get(
        url + "bitacora/",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 30));
      jsonResponse = json.decode(response.body)['data'];
      // Hive.box('empresasdb').put('data', jsonResponse);
      print(jsonResponse);
      return jsonResponse;
    } on Error catch (e) {
      return null;
    }
  }

  Future<bool> addBitacora(String bi_ciudad, String bi_lugar, String bi_desc,
      List<String> bi_logo) async {
    try {
      // socket = await socketRes().conexion();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        url + "bitacora",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "bi_ciudad": bi_ciudad,
          "bi_lugar": bi_lugar,
          "bi_desc": bi_desc,
          "bi_logo": json.encode(bi_logo),
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (exception) {
      print(exception);
      return false;
    }
  }
}
