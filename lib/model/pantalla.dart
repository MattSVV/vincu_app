
import 'package:hive/hive.dart';

part 'pantalla.g.dart';

@HiveType(typeId: 1)
class Pantalla {
  @HiveField(0)
  int idPantalla;
  @HiveField(1)
  String nombrePantalla;

  Pantalla({required this.idPantalla, required this.nombrePantalla});

  factory Pantalla.fromJson(Map<String, dynamic> json) {
    return Pantalla(
      idPantalla: json['id_Pantalla'],
      nombrePantalla: json['nombre_Pantalla'],
    );
  }

  factory Pantalla.defaultPantalla() {
  return Pantalla(idPantalla: -1, nombrePantalla: "Desconocida");
}
}
