class Convenio {
  final String co_cdgo;
  final String co_desc;
  final String tp_desc;

  Convenio({this.co_cdgo, this.co_desc, this.tp_desc});

  factory Convenio.fromJson(Map<String, dynamic> parsedJson) {
    return Convenio(
        co_cdgo: parsedJson['co_cdgo'].toString(),
        co_desc: parsedJson['co_desc'],
        tp_desc: parsedJson['tp_desc']);
  }
}
