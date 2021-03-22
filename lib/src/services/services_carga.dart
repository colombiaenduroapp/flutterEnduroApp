import 'package:ui_flutter/src/services/services_pqrs.dart';
import 'services_bitacora.dart';
import 'services_empresa.dart';
import 'services_sedes.dart';

class ServicioCarga {
  cargarNuevosDatos() async {
    await ServicioSede().cargarSedes(true);
    await ServicioEmpresa().getEmpresa(true);
    // await ServicioEvento().getEventos();
    await ServicioBitacoras().getBitacora(true);
    await ServicioPQRS().getPQRS();
  }
}
