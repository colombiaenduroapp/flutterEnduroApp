import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ui_flutter/src/pages/eventos.dart';
import 'package:ui_flutter/src/services/services_eventos.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class page_eventos_detalles extends StatefulWidget {
  final int ev_cdgo;
  page_eventos_detalles(this.ev_cdgo, {Key key}) : super(key: key);

  @override
  _page_eventos_detallesState createState() => _page_eventos_detallesState();
}

class _page_eventos_detallesState extends State<page_eventos_detalles> {
  Future<Evento> future_evento;
  Evento evento;
  String videoId;
  YoutubePlayerController _controller1;
  String titulo = 'Evento';

  @override
  void initState() {
    future_evento = ServicioEvento().searchEvento(widget.ev_cdgo.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: Text(titulo), actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.edit_outlined),
            iconSize: 30,
            tooltip: 'Editar',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    pagesEventos(widget.ev_cdgo.toString(), evento, 'Editar'),
              ),
            ),
          ),
        ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<Evento>(
                future: future_evento,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  evento = snapshot.data;
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: _imagen_evento(evento),
                          ),
                          _nombre_evento(evento),

                          // fechas
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Inicia:  ' + evento.ev_fecha_inicio,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Finaliza: ' + evento.ev_fecha_fin,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          // fin fechas
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Descripcion del evento',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black26, width: 1)),
                                padding: EdgeInsets.all(20),
                                alignment: Alignment.topLeft,
                                child: Text(evento.ev_lugar),
                              ),
                              // -----revisar
                              evento.ev_url_video != null
                                  ? Column(
                                      children: [
                                        Text(
                                          'Video del Evento',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          child: _cargar_video(
                                              evento.ev_url_video),
                                        ),
                                      ],
                                    )
                                  : Text('No hay video ha mostrar'),
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('vacio'),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  _imagen_evento(Evento evento) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FadeInImage.assetNetwork(
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        placeholder: 'assest/loading.gif',
        image: evento.ev_img,
      ),
    );
  }

  _nombre_evento(Evento evento) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(
        evento.ev_desc,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  _cargar_video(String ev_url_video) {
    videoId = YoutubePlayer.convertUrlToId(ev_url_video);
    _controller1 = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return YoutubePlayer(
      controller: _controller1,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,

      // bottomActions: [
      //   CurrentPosition(),
      //   ProgressBar(isExpanded: true),

      //   // TotalDuration(),
      // ],
    );
  }
}
