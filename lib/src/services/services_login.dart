import 'dart:convert';

import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioLogin {
  String url = Url().getUrl();
  Future<Login> signin(String email, String password) async {
    http.Response response;
    try {
      Login login;
      response = await http.post(url + 'auth/signin', body: {
        "email": email,
        "password": password,
      }).timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      login = Login.fromJson(jsonResponse);
      // print(login.message);
      return login;
    } catch (e) {
      print(e);
    }
  }
}

class Login {
  bool status;
  String message;
  String token;
  Login({this.status, this.message, this.token});
  factory Login.fromJson(Map<String, dynamic> json) {
    return new Login(
      status: json['status'],
      message: json['message'],
      token: json['token'],
    );
  }
}
