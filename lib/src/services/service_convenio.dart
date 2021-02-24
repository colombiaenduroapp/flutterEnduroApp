import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioConvenio {
  String url = Url().getUrl();

  Future<bool> addConvenio(
    String coDesc,
    String coEmpresaEmCdgo,
    String coTipoConveniosTpdgo,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        url + "convenios",
        headers: {
          "x-access-token": prefs.getString('token'),
        },
        body: {
          "co_desc": coDesc,
          "co_empresa_em_cdgo": coEmpresaEmCdgo,
          "co_tipo_convenios_tp_cdgo": coTipoConveniosTpdgo,
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (exception) {
      print(exception);
      return false;
    }
  }
}
