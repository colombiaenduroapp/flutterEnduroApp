import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ui_flutter/main.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioUsuario {
  String url = Url().getUrl();

  final int us_cdgo;
  final String us_clave;
  final String us_nombres;
  final String us_apellidos;
  final String us_alias;
  final String us_logo;
  final int us_perfil;
  final int us_sd_cdgo;
  final String us_correo;
  final String us_telefono;
  final String us_sexo;

  final String us_rh;

  final String us_direccion;

  ServicioUsuario(
      {this.us_cdgo,
      this.us_clave,
      this.us_nombres,
      this.us_apellidos,
      this.us_alias,
      this.us_logo,
      this.us_perfil,
      this.us_sd_cdgo,
      this.us_correo,
      this.us_telefono,
      this.us_sexo,
      this.us_rh,
      this.us_direccion});

  factory ServicioUsuario.fromJson(Map<String, dynamic> parsedJson) {
    return ServicioUsuario(
      us_cdgo: parsedJson['us_cdgo'],
      us_clave: parsedJson['us_clave'],
      us_nombres: parsedJson['us_nombres'],
      us_apellidos: parsedJson['us_apellidos'],
      us_alias: parsedJson['us_alias'],
      us_logo: parsedJson['us_logo'],
      us_perfil: parsedJson['us_perfil'],
      us_sd_cdgo: parsedJson['us_sd_cdgo'],
      us_correo: parsedJson['us_correo'],
      us_telefono: parsedJson['us_telefono'],
      us_sexo: parsedJson['us_sexo'],
      us_rh: parsedJson['us_rh'],
      us_direccion: parsedJson['us_direccion'],
    );
  }

  Future<dynamic> getSolicitudUsuarios() async {
    try {
      final response = await http.get(
        url + 'usuarios/solicitudes',
        headers: {'x-access-token': App.localStorage.getString('token')},
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final usuariosVieja =
            (Hive.box('solicitudusuariosdb').get('data') == null)
                ? []
                : Hive.box('solicitudusuariosdb').get('data');
        if (usuariosVieja.length < jsonResponse['data'].length) {
          final dif = jsonResponse['data'].length - usuariosVieja.length;
          App.localStorage.setInt('cambio_solicitudusuario', dif);
        }
        Hive.box('solicitudusuariosdb')
            .put('data', (jsonResponse['status']) ? jsonResponse['data'] : []);
      }
      final usuarios = Hive.box('solicitudusuariosdb').get('data');
      return usuarios;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addUsuario(
      String nombres,
      String apellidos,
      String telefono,
      String direccion,
      String logo,
      String sede,
      String alias,
      String sexo,
      String rh,
      String correo,
      String clave) async {
    try {
      final response = await http.post(
        url + 'usuarios',
        body: {
          'us_nombres': nombres,
          'us_apellidos': apellidos,
          'us_telefono': telefono,
          'us_direccion': direccion,
          'us_logo': logo,
          'us_sede_sd_cdgo': sede,
          'us_alias': alias,
          'us_sexo': sexo,
          'us_rh': rh,
          'us_correo': correo,
          'us_clave': clave,
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        App.conexion.emit('usuarios', [
          {'tipo': 'registro', 'sede': sede, 'alias': alias}
        ]);
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }

  Future<bool> validate(String tipo, String data) async {
    try {
      final response = await http
          .get(
            url + 'usuarios/validate?tipo=' + tipo + '&data=' + data,
          )
          .timeout(Duration(seconds: 20));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'];
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }

  Future<bool> updateEstado(String us_cdgo, String accion) async {
    try {
      final response = await http.put(
        url + "usuarios/cambio_estado/" + us_cdgo,
        headers: {
          "x-access-token": App.localStorage.getString('token'),
        },
        body: {
          "estado": (accion == "Aceptar") ? "1" : "0",
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        App.conexion.emit('usuarios', [
          {'tipo': 'actualizar', 'sede': null, 'alias': null}
        ]);
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }
}
