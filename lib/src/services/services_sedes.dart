import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/models/model_sede.dart';
import 'dart:async';

import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/widgets/widgets.dart';

import 'package:path_provider/path_provider.dart';

class ServicioSede {
  String url = Url().getUrl();
  String fileName = 'sedData.json';

  Future<SedesList> cargarSedes() async {
    var dir = await getTemporaryDirectory();
    File file = new File(dir.path + "/" + fileName);
    http.Response response;
    SedesList sedesList;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // if (file.existsSync()) {
    //   var jsonDtata = file.readAsStringSync();
    //   SedesList response = SedesList.fromJson((json.decode(jsonDtata)['data']));
    //   print('holaaa');
    //   return response;
    // }
    try {
      response = await http.get(
        url + "sede/",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 10));
      final jsonResponse = json.decode(response.body)['data'];
      sedesList = SedesList.fromJson(jsonResponse);
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }
    file.writeAsStringSync(response.body, flush: true, mode: FileMode.write);

    print('hola');
    return sedesList;
  }

  Future<List> getCiudad() async {
    http.Response response = await http.get(url + "sede/");
    if (response.statusCode == 200) {
      List res = jsonDecode(response.body)['data'];

      return res;
    } else {
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
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addSede(
      String cd_desc, String logo, String jersey, String ciudad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dir = await getTemporaryDirectory();
    File file = new File(dir.path + "/" + fileName);
    file.deleteSync();
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
      return true;
    } else {
      return false;
    }
  }
}

// ----------------------------------------------------------------------------------------
