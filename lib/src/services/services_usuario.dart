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
      print('hola');
      final response = await http.post(
        url + 'usuaris',
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
      print(response);
      if (response.statusCode == 200) {
        /* App.conexion.emit('sedes', [
          {'tipo': 'registro', 'sede': cd_desc}
        ]); */
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
