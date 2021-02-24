import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/models/model_evento.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioEvento {
  String url = Url().getUrl();

  Future<EventosList> getEventos() async {
    http.Response response;
    EventosList eventoList;
    var jsonResponse = null;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http.get(
        url + "evento/",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
      ).timeout(Duration(seconds: 10));
      jsonResponse = json.decode(response.body)['data'];
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }
    if (jsonResponse == null) {
      print(jsonResponse);
      return jsonResponse;
    } else {
      eventoList = EventosList.fromJson(jsonResponse);
      print(eventoList);
      return eventoList;
    }
  }

  Future<bool> addEvento(
      int us_cdgo,
      String ev_desc,
      DateTime ev_fecha_inicio,
      DateTime ev_fecha_fin,
      String ev_lugar,
      String ev_img,
      String ev_url_video) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        url + "evento",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "us_cdgo": us_cdgo.toString(),
          "ev_desc": ev_desc,
          "ev_fecha_inicio": ev_fecha_inicio.toString(),
          "ev_fecha_fin": ev_fecha_fin.toString(),
          "ev_lugar": ev_lugar,
          "ev_img": ev_img,
          "ev_url_video": ev_url_video,
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

  Future<Evento> searchEvento(String ev_cdgo) async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http.get(
        url + "evento/" + ev_cdgo,
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

      Evento evento = Evento.fromJson(jsonResponse);
      print(evento);
      return evento;
    } else {
      return null;
    }
  }

  Future<bool> updateSede(
      String ev_cdgo,
      int us_cdgo,
      String ev_desc,
      DateTime ev_fecha_inicio,
      DateTime ev_fecha_fin,
      String ev_lugar,
      String ev_img,
      String ev_url_img,
      String ev_url_video) async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      response = await http.put(
        url + "evento/" + ev_cdgo.toString(),
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "us_sede_sd_cdgo": '110',
          "us_cdgo": us_cdgo.toString(),
          "ev_desc": ev_desc,
          "ev_fecha_inicio": ev_fecha_inicio.toString(),
          "ev_fecha_fin": ev_fecha_fin.toString(),
          "ev_lugar": ev_lugar,
          "ev_img": ev_img,
          "ev_url_img": ev_url_img,
          "ev_url_video": ev_url_video,
        },
      ).timeout(Duration(seconds: 10));
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

  Future<bool> deleteEvento(String ev_cdgo) async {
    var response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      response = await http.delete(
        url + 'evento/' + ev_cdgo,
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
