import 'dart:convert';

import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioCiudad {
  String url = Url().getUrl();
  Future<Ciudad> getCiudad() async {
    Ciudad ciudad;
    http.Response response;
    try {
      response = await http.get(url + 'ciudad').timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      ciudad = Ciudad.fromJson(jsonResponse);
    } catch (e) {}
  }
}

class Ciudad {
  int cd_cdgo;
  String cd_desc;
  Ciudad({this.cd_cdgo, this.cd_desc});
  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return new Ciudad(
      cd_cdgo: json['cd_cdgo'],
      cd_desc: json['cd_desc'],
    );
  }
}
