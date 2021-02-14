class Empresa {
  final int em_cdgo;
  final String em_nit;
  final String em_logo;
  final String em_nombre;
  final String em_desc;
  final String em_telefono;
  final String em_correo;
  final String em_error;

  Empresa(
      {this.em_cdgo,
      this.em_nit,
      this.em_logo,
      this.em_nombre,
      this.em_desc,
      this.em_telefono,
      this.em_correo,
      this.em_error});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return new Empresa(
        em_cdgo: json['em_cdgo'],
        em_nit: json['em_nit'],
        em_logo: json['em_logo'],
        em_nombre: json['em_nombre'],
        em_desc: json['em_desc'],
        em_telefono: json['em_telefono'],
        em_correo: json['em_correo'],
        em_error: json['em_error']);
  }
}

class EmpresaList {
  final List<Empresa> empresas;

  EmpresaList({
    this.empresas,
  });

  factory EmpresaList.fromJson(List<dynamic> parsedJson) {
    List<Empresa> empresas;
    empresas = parsedJson.map((i) => Empresa.fromJson(i)).toList();

    return new EmpresaList(empresas: empresas);
  }
}
