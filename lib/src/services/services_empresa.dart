import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/models/model_empresa.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;
import 'package:ui_flutter/src/services/socket.dart';

class ServicioEmpresa {
  String url = Url().getUrl();
  SocketIO socket;

  Future<dynamic> getEmpresa(bool cambio) async {
    var jsonResponse;
    http.Response response;
    // EmpresaList empresalist;
    try {
      final empresas = Hive.box('empresasdb').get('data', defaultValue: []);
      if (!cambio) {
        if (empresas.isNotEmpty) {
          return empresas;
        }
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.get(
        url + "empresa/",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 30));
      jsonResponse = json.decode(response.body)['data'];
      final dif = jsonResponse.length - empresas.length;
      if (empresas.length < jsonResponse.length)
        App.localStorage.setInt('cambio_empresa', dif);
      Hive.box('empresasdb').put('data', jsonResponse);

      return jsonResponse;
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }
  }

  Future<bool> addEmpresa(
    String em_nit,
    String em_logo,
    String em_nombre,
    String em_desc,
    String em_telefono,
    String em_correo,
  ) async {
    try {
      socket = await ServicioSocket().conexion();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        url + "empresa",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "em_nit": em_nit,
          "em_logo": em_logo,
          "em_nombre": em_nombre,
          "em_desc": em_desc,
          "em_telefono": em_telefono,
          "em_correo": em_correo,
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

  // -----------------

  Future<Empresa> searchEmpresa(String em_cdgo) async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.get(
        url + "empresa/" + em_cdgo,
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 40));
    } on TimeoutException catch (e) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    }

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'];
      Empresa evento = Empresa.fromJson(jsonResponse);
      return evento;
    } else {
      return null;
    }
  }

  Future<bool> updateEmpresa(
      String em_cdgo,
      String em_nit,
      String em_logo,
      String em_logo_url,
      String em_nombre,
      String em_desc,
      String em_telefono,
      String em_correo) async {
    var response;
    SocketIO socket = await ServicioSocket().conexion();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.put(
        url + "empresa/" + em_cdgo,
        headers: {"x-access-token": prefs.getString('token')},
        body: {
          "em_nit": em_nit,
          "em_logo": em_logo,
          "em_logo_url": em_logo_url,
          "em_nombre": em_nombre,
          "em_desc": em_desc,
          "em_telefono": em_telefono,
          "em_correo": em_correo,
        },
      ).timeout(Duration(seconds: 40));
    } on TimeoutException catch (e) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    }
    if (response.statusCode == 200) {
      print('hola mundp');
      socket.emit('empresas', ['true']);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteEmpresa(String em_cdgo) async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.delete(
        url + 'empresa/' + em_cdgo,
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      );
    } catch (error) {}
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
