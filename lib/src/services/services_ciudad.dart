import 'package:ui_flutter/src/services/service_url.dart';

class ServicioCiudad {
  String url = Url().getUrl();
  // Future<Ciudad> getCiudad() async {
  //   http.Response response;
  //   try {
  //     Ciudad ciudad;
  //     response = await http.get(url + 'ciudad').timeout(Duration(seconds: 30));
  //     final jsonResponse = json.decode(response.body)['data'];
  //     ciudad = Ciudad.fromJson(jsonResponse);
  //     return ciudad;
  //   } catch (e) {}
  // }
}

class Ciudad {
  int cd_cdgo;
  String cd_desc;
  Ciudad({this.cd_cdgo, this.cd_desc});
  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return new Ciudad(
      cd_cdgo: json['cd_cdgo'],
      cd_desc: json['cd_desc'],
    );
  }
}
