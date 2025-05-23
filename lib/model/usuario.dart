import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 2)
class Usuario {
  @HiveField(0)
  int idUsuario;
  @HiveField(1)
  String cedulaUsuario;
  @HiveField(2)
  String contraUsuario;

  Usuario({
    required this.idUsuario,
    required this.cedulaUsuario,
    required this.contraUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_Usuario'],
      cedulaUsuario: json['cedula_Usuario'],
      contraUsuario: json['contra_Usuario'],
    );
  }
}
