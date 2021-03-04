import 'package:adhara_socket_io/adhara_socket_io.dart';

class socketRes {
  Future<SocketIO> conexion() async {
    String URI = "https://colombiaenduro.herokuapp.com/";
    SocketIOManager manager;
    SocketIO socket;
    manager = SocketIOManager();
    socket =
        await manager.createInstance(SocketOptions(URI, enableLogging: false));

    socket.onConnect((data) {
      print("Conectado.. adhara.");
    });

    socket.connect();
    return socket;
  }
}
