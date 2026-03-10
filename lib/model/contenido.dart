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

  Object? toJson() {
    return {
      'id_Contenido': idContenido,
      'titulo_Contenido': tituloContenido,
      'subtitulo_Contenido': subtituloContenido,
      'descripcion_Contenido': descripcionContenido,
      'id_Pantalla': pantalla.idPantalla,
      'id_Departamento': departamento.idDepartamento,
    };
  }

  factory Contenido.defaultContenido() {
    return Contenido(
      0,
      '',
      '',
      '',
      Departamento.defaultDepartamento(),
      Pantalla.defaultPantalla(),
    );
  }

}
