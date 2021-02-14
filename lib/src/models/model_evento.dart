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
  final int ev_faltante;
  final String ev_url_video;
  final int ev_estado_ev;

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
    this.ev_faltante,
    this.ev_url_video,
    this.ev_estado_ev,
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
        ev_faltante: json['ev_faltante'],
        ev_url_video: json['ev_url_video'],
        ev_estado_ev: json['ev_estado_ev']);
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
