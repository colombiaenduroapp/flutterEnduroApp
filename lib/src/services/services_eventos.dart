import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioEvento {
  String url = Url().getUrl();

  Future<EventosList> getEventos() async {
    http.Response response;
    EventosList eventoList;
    try {
      response = await http.get(url + "evento/").timeout(Duration(seconds: 30));
      final jsonResponse = json.decode(response.body)['data'];
      eventoList = EventosList.fromJson(jsonResponse);
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    } on Error catch (e) {
      return null;
    }

    return eventoList;
  }

  Future<bool> addEvento(
      int us_sede_sd_cdgo,
      int us_cdgo,
      String ev_desc,
      DateTime ev_fecha_inicio,
      DateTime ev_fecha_fin,
      String ev_lugar,
      String ev_img) async {
    try {
      final response = await http.post(
        url + "evento",
        body: {
          "us_sede_sd_cdgo": us_sede_sd_cdgo.toString(),
          "us_cdgo": us_cdgo.toString(),
          "ev_desc": ev_desc,
          "ev_fecha_inicio": ev_fecha_inicio.toString(),
          "ev_fecha_fin": ev_fecha_fin.toString(),
          "ev_lugar": ev_lugar,
          "ev_img": ev_img,
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
}

class Evento {
  final int ev_cdgo;
  final int ev_sede_sd_cdgo;
  final int ev_usuario_us_cdgo;
  final String ev_fecha_inicio;
  final String ev_fecha_fin;
  final String ev_desc;
  final String ev_lugar;
  final String ev_img;
  final String us_nombres;
  final String sd_desc;

  Evento({
    this.ev_cdgo,
    this.ev_sede_sd_cdgo,
    this.ev_usuario_us_cdgo,
    this.ev_fecha_inicio,
    this.ev_fecha_fin,
    this.ev_desc,
    this.ev_lugar,
    this.ev_img,
    this.us_nombres,
    this.sd_desc,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return new Evento(
      ev_cdgo: json['ev_cdgo'],
      ev_sede_sd_cdgo: json['ev_sede_sd_cdgo'],
      ev_usuario_us_cdgo: json['ev_usuario_us_cdgo'],
      ev_fecha_inicio: json['ev_fecha_inicio'],
      ev_fecha_fin: json['ev_fecha_fin'],
      ev_desc: json['ev_desc'],
      ev_lugar: json['ev_lugar'],
      ev_img: json['ev_img'],
      us_nombres: json['us_nombres'],
      sd_desc: json['sd_desc'],
    );
  }
}

class EventosList {
  final List<Evento> eventos;

  EventosList({
    this.eventos,
  });

  factory EventosList.fromJson(List<dynamic> parsedJson) {
    List<Evento> eventos = new List<Evento>();
    eventos = parsedJson.map((i) => Evento.fromJson(i)).toList();

    return new EventosList(eventos: eventos);
  }
}
