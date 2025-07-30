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
      'id_contenido': idContenido,
      'titulo_contenido': tituloContenido,
      'subtitulo_contenido': subtituloContenido,
      'descripcion_contenido': descripcionContenido,
      'id_departamento': departamento.idDepartamento,
      'id_pantalla': pantalla.idPantalla,
    };
  }

  
  
}
