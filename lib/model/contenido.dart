import 'package:hive/hive.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';

part 'contenido.g.dart';

@HiveType(typeId: 3)
class Contenido {
  @HiveField(0)
  int idContenido;
  @HiveField(1)
  String tituloContenido;
  @HiveField(2)
  String subtituloContenido;
  @HiveField(3)
  String descripcionContenido;
  @HiveField(4)
  Departamento departamento;
  @HiveField(5)
  Pantalla pantalla;

  Contenido(
    this.idContenido,
    this.tituloContenido,
    this.subtituloContenido,
    this.descripcionContenido,
    this.departamento,
    this.pantalla,
  );

  
  
}
