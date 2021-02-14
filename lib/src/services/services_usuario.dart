class Usuario {
  final int us_cdgo;
  final String us_clave;
  final String us_nombres;
  final String us_apellidos;
  final String us_alias;
  final String us_logo;
  final int us_perfil;
  final String us_sd_cdgo;
  final String us_correo;
  final String us_telefono;
  final String us_sexo;

  final String us_rh;

  final String us_direccion;

  Usuario(
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

  factory Usuario.fromJson(Map<String, dynamic> parsedJson) {
    return Usuario(
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
}
