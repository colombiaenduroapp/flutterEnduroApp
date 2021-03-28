import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:ui_flutter/src/services/services_pqrs.dart';

import '../../main.dart';
import 'local_notification.dart';
import 'services_bitacora.dart';
import 'services_empresa.dart';
import 'services_sedes.dart';

class ServicioSocket {
  LocalNotification localNotification = new LocalNotification();
  String url = Url().getUrl();

  Future<SocketIO> conexion() async {
    SocketIOManager manager;
    SocketIO socket;

    manager = SocketIOManager();
    socket = await manager.createInstance(SocketOptions(url,
        enableLogging: false,
        query: {'uid': App.localStorage.getInt('us_cdgo').toString()}));

    socket.onConnect((data) {
      print("Conectado.. adhara.");
    });

    socket.connect();
    return socket;
  }

  iniciaSockets() async {
    socketBitacoras(App.conexion);
    socketEmpresas(App.conexion);
    socketSedes(App.conexion);
    socketPqrs(App.conexion);
    socketPublicacionesMasivas(App.conexion);
  }

  // ------------------socket sede-----------
  socketSedes(SocketIO socket) {
    socket.on('sedesres', (data) {
      if (data['tipo'] == "registro")
        localNotification.scheduleNotification(
            'Se ha registrado una nueva sede ', data['sede']);

      ServicioSede().cargarSedes(true);
    });
  }

// ------------------socket bitacoras-----------
  socketBitacoras(SocketIO socket) {
    socket.on('bitacorasres', (data) {
      if (data['tipo'] == "registro")
        localNotification.scheduleNotification(
            'Se ha registrado una nueva bitacora ', data['lugar']);

      ServicioBitacoras().getBitacora(true);
    });
  }

// ------------------socket empresas-----------
  socketEmpresas(SocketIO socket) {
    socket.on('empresasres', (_) {
      print('empresas cambio');
      ServicioEmpresa().getEmpresa(true);
    });
  }

  socketPqrs(SocketIO socket) {
    socket.on('pqrsres', (data) {
      if (App.localStorage.getInt('us_perfil') == 3)
        localNotification.scheduleNotification(
            'Se ha registrado una nueva queja ', data['pqrs']);

      ServicioPQRS().getPQRS();
    });
  }

  socketPublicacionesMasivas(SocketIO socket) {
    socket.on('publicacionesmasivasres', (data) {
      if (App.localStorage.getInt('us_perfil') == 3)
        localNotification.scheduleNotification(
            'Se ha registrado una nueva solicitud ', data['pqrs']);

      ServicioPQRS().getPQRS();
    });
  }
}
