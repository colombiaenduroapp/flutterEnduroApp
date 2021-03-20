import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ui_flutter/src/services/services_eventos.dart';
import 'package:ui_flutter/src/services/services_pqrs.dart';
import 'package:ui_flutter/src/services/socket.dart';

import 'local_notification.dart';
import 'services_bitacora.dart';
import 'services_empresa.dart';
import 'services_sedes.dart';

class ServicioCarga {
  LocalNotification localNotification = new LocalNotification();
  List viejaSede, nuevaSede;
  List viejaEmpresa, nuevaEmpresa;
  List viejaEvento, nuevaEvento;
  List viejaBitacora, nuevaBitacora;
  List viejaPqrs, nuevaPqrs;
  ServicioCarga() {}

  iniciaSockets() async {
    SocketIO socket = await socketRes().conexion();
    socketBitacoras(socket);
    socketEmpresas(socket);
    socketSedes(socket);
  }

  cargarNuevosDatos() async {
    nuevaSede = await ServicioSede().cargarSedes(true);
    nuevaEmpresa = await ServicioEmpresa().getEmpresa(true);
    // nuevaEvento = await ServicioEvento().getEventos();
    nuevaBitacora = await ServicioBitacoras().getBitacora(true);
    nuevaPqrs = await ServicioPQRS().getPQRS();
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
}
