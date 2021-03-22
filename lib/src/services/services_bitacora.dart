import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/socket.dart';

class ServicioBitacoras {
  String url = Url().getUrl();
  SocketIO socket;

  Future<dynamic> getBitacora(bool cambio) async {
    var jsonResponse;
    http.Response response;
    try {
      final bitacoras = Hive.box('bitacorasdb').get('data', defaultValue: []);
      if (!cambio) {
        if (bitacoras.isNotEmpty) {
          return bitacoras;
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.get(
        url + "bitacora/",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 30));
      jsonResponse = json.decode(response.body)['data'];
      final dif = jsonResponse.length - bitacoras.length;
      if (bitacoras.length < jsonResponse.length)
        App.localStorage.setInt('cambio_bitacora', dif);
      Hive.box('bitacorasdb').put('data', jsonResponse);
      return jsonResponse;
    } on Error catch (e) {
      return e;
    }
  }

  Future<bool> addBitacora(String bi_ciudad, String bi_lugar, String bi_desc,
      List<String> bi_logo) async {
    try {
      socket = await ServicioSocket().conexion();
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
        socket.emit('bitacoras', [
          {'tipo': 'registro', 'lugar': bi_lugar}
        ]);
        return true;
      } else if (response.statusCode == 403) {
        print('error token');
        App.localStorage.setString('token', null);
        return null;
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
