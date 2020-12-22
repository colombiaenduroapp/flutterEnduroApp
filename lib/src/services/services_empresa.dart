import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioEmpresa {
  String url = Url().getUrl();

  Future<EmpresaList> getEmpresa() async {
    http.Response response;
    EmpresaList empresalist;
    try {
      response =
          await http.get(url + "empresa/").timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      empresalist = EmpresaList.fromJson(jsonResponse);
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }

    return empresalist;
  }

  Future<bool> addEmpresa(String em_nit, String em_logo, String em_nombre,
      String em_desc, String em_telefono, String em_correo) async {
    try {
      final response = await http.post(
        url + "empresa",
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
      response = await http
          .get(url + "empresa/" + em_cdgo)
          .timeout(Duration(seconds: 40));
    } on TimeoutException catch (e) {
      print('Timeout');
    } on Error catch (e) {
      print('Error: $e');
    }

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body)['data'];

      Empresa evento = Empresa.fromJson(jsonResponse);
      print(evento);
      return evento;
    } else {
      return null;
    }
  }

  // Future<bool> updateSede(
  //     String ev_cdgo,
  //     int us_sede_sd_cdgo,
  //     int us_cdgo,
  //     String ev_desc,
  //     DateTime ev_fecha_inicio,
  //     DateTime ev_fecha_fin,
  //     String ev_lugar,
  //     String ev_img,
  //     String ev_url_img,
  //     String ev_url_video) async {
  //   var response;
  //   try {
  //     response = await http.post(
  //       url + "evento/" + ev_cdgo,
  //       body: {
  //         "us_sede_sd_cdgo": us_sede_sd_cdgo.toString(),
  //         "us_cdgo": us_cdgo.toString(),
  //         "ev_desc": ev_desc,
  //         "ev_fecha_inicio": ev_fecha_inicio.toString(),
  //         "ev_fecha_fin": ev_fecha_fin.toString(),
  //         "ev_lugar": ev_lugar,
  //         "ev_img": ev_img,
  //         "ev_url_img": ev_url_img,
  //         "ev_url_video": ev_url_video,
  //       },
  //     ).timeout(Duration(seconds: 40));
  //   } on TimeoutException catch (e) {
  //     print('Timeout');
  //   } on Error catch (e) {
  //     print('Error: $e');
  //   }
  //   if (response.statusCode == 200) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

}

class Empresa {
  final int em_cdgo;
  final String em_nit;
  final String em_logo;
  final String em_nombre;
  final String em_desc;
  final String em_telefono;
  final String em_correo;

  Empresa({
    this.em_cdgo,
    this.em_nit,
    this.em_logo,
    this.em_nombre,
    this.em_desc,
    this.em_telefono,
    this.em_correo,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return new Empresa(
      em_cdgo: json['em_cdgo'],
      em_nit: json['em_nit'],
      em_logo: json['em_logo'],
      em_nombre: json['em_nombre'],
      em_desc: json['em_desc'],
      em_telefono: json['em_telefono'],
      em_correo: json['em_correo'],
    );
  }
}

class EmpresaList {
  final List<Empresa> empresas;

  EmpresaList({
    this.empresas,
  });

  factory EmpresaList.fromJson(List<dynamic> parsedJson) {
    List<Empresa> empresas = new List<Empresa>();
    empresas = parsedJson.map((i) => Empresa.fromJson(i)).toList();

    return new EmpresaList(empresas: empresas);
  }
}
