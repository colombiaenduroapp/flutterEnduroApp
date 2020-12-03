import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ServicioCiudad {
  Future<SedesList> cargarSedes() async {
    http.Response response =
        await http.get("http://192.168.100.181:5000/sede/");
    final jsonResponse = json.decode(response.body)['data'];
    SedesList sedesList = SedesList.fromJson(jsonResponse);
    return sedesList;
  }

  Future<List> getCiudad() async {
    http.Response response =
        await http.get("http://192.168.100.181:5000/sede/");
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
      String url = "http://192.168.100.181:5000/sede/";
      response = await http.get(url + sd_cdgo).timeout(Duration(seconds: 40));
    } on TimeoutException catch (e) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    }

    if (response.statusCode == 200) {
      return Sede.fromJson(json.decode(response.body)['data']);
    } else {
      return null;
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
        // 192.168.1.100 terro
        "http://192.168.100.181:5000/sede",
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
  final String sd_desc;
  final String sd_logo;
  final String sd_jersey;
  final String cd_desc;
  final String sd_estado;
  Sede(
      {this.sd_cdgo,
      this.sd_desc,
      this.sd_logo,
      this.sd_jersey,
      this.cd_desc,
      this.sd_estado});

  factory Sede.fromJson(Map<String, dynamic> json) {
    return new Sede(
      sd_cdgo: json['sd_cdgo'],
      sd_desc: json['sd_desc'],
      sd_logo: json['sd_logo'],
      sd_jersey: json['sd_jersey'],
      cd_desc: json['sd_jersey'],
      sd_estado: json['sd_estado'].toString(),
    );
  }
}
