import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ui_flutter/src/pages/login.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PageConocenos extends StatefulWidget {
  @override
  _PageConocenosState createState() => _PageConocenosState();
}

class _PageConocenosState extends State<PageConocenos> {
  final int _numPages = 3;
  final String url_video =
      'https://www.youtube.com/watch?v=HKC5cnpgAnQ&ab_channel=DavidMetalBiker';
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Theme.of(context).accentColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageLogin(),
          ),
        ),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 0.7, 0.9],
                colors: [
                  Colors.blueGrey[300],
                  Colors.blueGrey[400],
                  Colors.blueGrey[500],
                  Colors.blueGrey[600],
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () => print('Skip'),
                      child: Text(
                        'Saltar',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 600.0,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/mision.png',
                                  ),
                                  height: 200.0,
                                  width: 600.0,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                'Colombia Enduro',
                                // style: kTitleStyle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Somos un club multimarcas y multicilindrajes de personas naturales sin animo de lucro, que se dedican principalmente a promover y realizar diferentes actividades con las motosque generen espacion de distraccion y apoyo a la comunidad atraves de obras sociales, integrando principios de cultura, respeto por las normas de transito.', // style: kSubtitleStyle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/vision.png',
                                  ),
                                  height: 200.0,
                                  width: 600.0,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Text(
                                'Colombia Enduro',
                                // style: kTitleStyle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Ser reconocidos como Club Motero organizado para mejorar la percepción  con la que es vista los motociclistas por parte del publico en general \n Ser el punto de motivación a todas las personas que comparten una pasión por las motos y seguir promoviendo actividades de sentido social', // style: kSubtitleStyle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: url_video != null
                                    ? Column(
                                        children: [
                                          Text(
                                            'Video de invitación',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: _cargar_video(url_video),
                                          ),
                                        ],
                                      )
                                    : Text('No hay video ha mostrar'),
                              ),
                              SizedBox(height: 40.0),
                              Center(
                                child: Text(
                                  'Contactanos',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: GFButton(
                                  type: GFButtonType.outline,
                                  shape: GFButtonShape.pills,
                                  color: Colors.white,
                                  onPressed: () {
                                    launch(('tel://312567e7'));
                                  },
                                  child: Text(
                                    'Comunicate con nosotros...',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 15),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GFIconButton(
                                      onPressed: () {},
                                      // shape: GFIconButtonShape.pills,
                                      type: GFButtonType.solid,
                                      icon: FaIcon(FontAwesomeIcons.facebook),
                                    ),
                                    GFIconButton(
                                      onPressed: () {},
                                      // shape: GFIconButtonShape.pills,
                                      type: GFButtonType.solid,
                                      color: GFColors.SUCCESS,
                                      icon: FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                        // color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                  _currentPage != _numPages - 1
                      ? Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: FlatButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Siguiente',
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageLogin(),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Empezar',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }

  String videoId;
  YoutubePlayerController _controller1;
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
