import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ServicioCiudad {
  Future<List> getCiudad() async {
    http.Response response = await http.get("http://192.168.1.100:5000/sede");
    if (response.statusCode == 200) {
      List res = jsonDecode(response.body)['data'];

      return res;
    } else {
      return null;
    }
  }

  Future<bool> addSede(
      String cd_desc, String logo, String jersey, String ciudad) async {
    final response = await http.post(
      "http://192.168.1.100:5000/sede",
      body: {
        "sd_desc": cd_desc,
        "sd_logo": logo,
        "sd_jersey": jersey,
        "sd_ciudad_cd_cdgo": ciudad,
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
