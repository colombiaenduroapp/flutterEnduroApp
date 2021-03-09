import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/services/service_url.dart';

class socketRes {
  String url = Url().getUrl();
  Future<SocketIO> conexion() async {
    SocketIOManager manager;
    SocketIO socket;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    manager = SocketIOManager();
    socket = await manager.createInstance(SocketOptions(url,
        enableLogging: false, query: {'uid': prefs.getString('us_nombres')}));

    socket.onConnect((data) {
      print("Conectado.. adhara.");
    });

    socket.connect();
    return socket;
  }
}
