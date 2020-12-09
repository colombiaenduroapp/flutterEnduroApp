import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:ui_flutter/src/services/service_url.dart';

class ServicioSede {
  String url = Url().getUrl();

  Future<SedesList> cargarSedes() async {
    http.Response response;
    SedesList sedesList;
    try {
      response = await http.get(url + "sede/").timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      sedesList = SedesList.fromJson(jsonResponse);
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }

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
    try {
      response = await http
          .get(url + "sede/" + sd_cdgo)
          .timeout(Duration(seconds: 40));
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
    try {
      response = await http.post(
        url + "sede/" + sd_cdgo,
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
    CircularProgressIndicator(
      backgroundColor: Colors.cyan,
      strokeWidth: 5,
    );
    try {
      final response = await http.post(
        url + "sede",
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
}

// ----------------------------------------------------------------------------------------

class SedesList {
  final List<Sede> sedes;

  SedesList({
    this.sedes,
  });

  factory SedesList.fromJson(List<dynamic> parsedJson) {
    List<Sede> sedes = new List<Sede>();
    sedes = parsedJson.map((i) => Sede.fromJson(i)).toList();

    return new SedesList(sedes: sedes);
  }
}

class Sede {
  final int sd_cdgo;
  String sd_desc;
  final String sd_logo;
  final String sd_jersey;
  final String cd_cdgo;
  final String cd_desc;
  final String sd_estado;
  final List<Mesa> mesas;

  Sede(
      {this.sd_cdgo,
      this.sd_desc,
      this.sd_logo,
      this.sd_jersey,
      this.cd_cdgo,
      this.cd_desc,
      this.sd_estado,
      this.mesas});

  factory Sede.fromJson(Map<String, dynamic> json) {
    if (json['sd_mesa_trabajo'] != null) {
      var list = json['sd_mesa_trabajo'] as List;
      List<Mesa> imagesList = list.map((i) => Mesa.fromJson(i)).toList();
      return new Sede(
          sd_cdgo: json['sd_cdgo'],
          sd_desc: json['sd_desc'],
          sd_logo: json['sd_logo'],
          sd_jersey: json['sd_jersey'],
          cd_cdgo: json['cd_cdgo'].toString(),
          cd_desc: json['cd_desc'],
          sd_estado: json['sd_estado'].toString(),
          mesas: imagesList);
    } else {
      return new Sede(
          sd_cdgo: json['sd_cdgo'],
          sd_desc: json['sd_desc'],
          sd_logo: json['sd_logo'],
          sd_jersey: json['sd_jersey'],
          cd_cdgo: json['cd_cdgo'].toString(),
          cd_desc: json['cd_desc'],
          sd_estado: json['sd_estado'].toString());
    }
  }
}

class Mesa {
  final String us_nombres;
  final String us_alias;
  final String ca_desc;

  Mesa({this.us_nombres, this.us_alias, this.ca_desc});

  factory Mesa.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['us_alias'] != null) {
      return Mesa(
          us_nombres: parsedJson['us_nombres'],
          ca_desc: parsedJson['ca_desc'],
          us_alias: parsedJson['us_alias']);
    } else {
      return Mesa(
          us_nombres: parsedJson['us_nombres'], ca_desc: parsedJson['ca_desc']);
    }
  }
}
