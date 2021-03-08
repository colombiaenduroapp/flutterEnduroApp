import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class socketRes {
  Future<SocketIO> conexion() async {
    String URI = "http://192.168.100.181:5000/";
    SocketIOManager manager;
    SocketIO socket;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    manager = SocketIOManager();
    socket = await manager.createInstance(SocketOptions(URI,
        enableLogging: false, query: {'uid': prefs.getString('us_nombres')}));

    socket.onConnect((data) {
      print("Conectado.. adhara.");
    });

    socket.connect();
    return socket;
  }
}
