import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/models/model_sede.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/socket.dart';

class ServicioSede {
  String url = Url().getUrl();
// esta funcion carga la lista de sedes la variable cambio sirve para determinar
// si hubieron cambion en el servidor  true=hubieron cambios, false=no hubieron cambios
  Future<dynamic> cargarSedes(bool cambio) async {
    http.Response response;
    // SedesList sedesList;
    var jsonResponse;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final sedes = Hive.box('sedesdb').get('data', defaultValue: []);
      if (!cambio) {
        if (sedes.isNotEmpty) {
          return sedes;
        }
      } else {
        response = await http.get(
          url + "sede/",
          headers: {
            "x-access-token": prefs.getString('token'),
          },
        ).timeout(Duration(seconds: 10));
        jsonResponse = json.decode(response.body)['data'];
        if (response.statusCode == 200) {
          final dif = jsonResponse.length - sedes.length;
          if (sedes.length < jsonResponse.length)
            App.localStorage.setInt('cambio_sede', dif);
          Hive.box('sedesdb').put('data', jsonResponse);

          return jsonResponse;
        }
        // Error de token
        else if (response.statusCode == 403) {
          App.localStorage.setString('token', null);
          return sedes;
        }
        // sedesList = SedesList.fromJson(jsonResponse);

      }
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }
  }

  Future<Sede> searchSede(String sd_cdgo) async {
    var response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      response = await http.get(
        url + "sede/" + sd_cdgo,
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
      App.conexion.emit('sedes', [
        {'tipo': 'registro', 'sede': 'sjdh'}
      ]);
      final jsonResponse = json.decode(response.body)['data'];
      Sede sede = Sede.fromJson(jsonResponse);
      return sede;
    } else {
      return null;
    }
  }

  Future<bool> updateSede(String sd_cdgo, String cd_desc, String logo,
      String url_logo, String jersey, String url_jersey, String ciudad) async {
    var response;
    SocketIO socket = await ServicioSocket().conexion();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      response = await http.put(
        url + "sede/" + sd_cdgo,
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "sd_desc": cd_desc,
          "sd_logo": logo,
          "sd_url_logo": url_logo,
          "sd_jersey": jersey,
          "sd_url_jersey": url_jersey,
          "sd_ciudad_cd_cdgo": ciudad,
        },
      ).timeout(Duration(seconds: 40));
    } on TimeoutException catch (e) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    }
    if (response.statusCode == 200) {
      socket.emit('sedes', [
        {'tipo': 'registro', 'sede': cd_desc}
      ]);
      return true;
    } else if (response.statusCode == 403) {
      App.localStorage.setString('token', null);
      return null;
    } else {
      return false;
    }
  }

  Future<bool> addSede(
      String cd_desc, String logo, String jersey, String ciudad) async {
    SocketIO socket = await ServicioSocket().conexion();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        url + "sede",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "sd_desc": cd_desc,
          "sd_logo": logo,
          "sd_jersey": jersey,
          "sd_ciudad_cd_cdgo": ciudad,
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        socket.emit('sedes', [
          {'tipo': 'registro', 'sede': cd_desc}
        ]);
        return true;
      } else if (response.statusCode == 403) {
        App.localStorage.setString('token', null);
        return null;
      } else {
        return false;
      }
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  Future<bool> addMesa(DateTime mt_fecha, String mt_cargo_ca_cdgo,
      String mt_usuario_us_cdgo, String mt_sede_sd_cdgo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(
        url + "mesa_trabajo",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "mt_fecha": mt_fecha.toString(),
          "mt_cargo_ca_cdgo": mt_cargo_ca_cdgo,
          "mt_usuario_us_cdgo": mt_usuario_us_cdgo,
          "mt_sede_sd_cdgo": mt_sede_sd_cdgo,
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      print(exception);
      return false;
    }
  }

  Future<bool> deleteMesa(String sd_cdgo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.delete(
        url + "mesa_trabajo/" + sd_cdgo,
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      print(exception);
      return false;
    }
  }
// ----------------------------------------------------------------------------------------

  Future<bool> deleteSede(String sd_cdgo) async {
    var response;
    SocketIO socket = await ServicioSocket().conexion();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      response = await http.delete(
        url + 'sede/' + sd_cdgo,
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      );
    } catch (error) {}
    if (response.statusCode == 200) {
      socket.emit('sedes', [
        {'tipo': 'Eliminar', 'sede': sd_cdgo}
      ]);
      return true;
    } else {
      return false;
    }
  }
}

// ----------------------------------------------------------------------------------------
