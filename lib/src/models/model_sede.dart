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
  String sd_desc;
  final String sd_logo;
  final String sd_jersey;
  final String cd_cdgo;
  final String cd_desc;
  final String sd_estado;
  final List<Mesa> mesas;

  Sede(
      {this.sd_cdgo,
      this.sd_desc,
      this.sd_logo,
      this.sd_jersey,
      this.cd_cdgo,
      this.cd_desc,
      this.sd_estado,
      this.mesas});

  factory Sede.fromJson(Map<String, dynamic> json) {
    if (json['sd_mesa_trabajo'] != null) {
      var list = json['sd_mesa_trabajo'] as List;
      List<Mesa> imagesList = list.map((i) => Mesa.fromJson(i)).toList();
      return new Sede(
          sd_cdgo: json['sd_cdgo'],
          sd_desc: json['sd_desc'],
          sd_logo: json['sd_logo'],
          sd_jersey: json['sd_jersey'],
          cd_cdgo: json['cd_cdgo'].toString(),
          cd_desc: json['cd_desc'],
          sd_estado: json['sd_estado'].toString(),
          mesas: imagesList);
    } else {
      return new Sede(
          sd_cdgo: json['sd_cdgo'],
          sd_desc: json['sd_desc'],
          sd_logo: json['sd_logo'],
          sd_jersey: json['sd_jersey'],
          cd_cdgo: json['cd_cdgo'].toString(),
          cd_desc: json['cd_desc'],
          sd_estado: json['sd_estado'].toString());
    }
  }
}

class Mesa {
  final String us_nombres;
  final String us_alias;
  final String ca_desc;

  Mesa({this.us_nombres, this.us_alias, this.ca_desc});

  factory Mesa.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['us_alias'] != null) {
      return Mesa(
          us_nombres: parsedJson['us_nombres'],
          ca_desc: parsedJson['ca_desc'],
          us_alias: parsedJson['us_alias']);
    } else {
      return Mesa(
          us_nombres: parsedJson['us_nombres'], ca_desc: parsedJson['ca_desc']);
    }
  }
}
