import 'package:hive/hive.dart';

part 'departamento.g.dart';

@HiveType(typeId: 0)
class Departamento {
  @HiveField(0)
  int idDepartamento;
  @HiveField(1)
  String nombreDepartamento;

  Departamento({
    required this.idDepartamento,
    required this.nombreDepartamento,
  });

  factory Departamento.defaultDepartamento() {
  return Departamento(idDepartamento: -1, nombreDepartamento: "Desconocido");
}

  factory Departamento.fromJson(Map<String, dynamic> json) {
    return Departamento(
      idDepartamento: json['id_departamento'],
      nombreDepartamento: json['nombre_departamento'],
    );
  }
}
