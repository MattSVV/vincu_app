
import 'package:hive/hive.dart';
import 'package:vincu_app/model/departamento.dart';


part 'archivo.g.dart';

@HiveType(typeId: 4)
class Archivo {
  @HiveField(0)
  int idArchivo;
  @HiveField(1)
  String tituloArchivo;
  @HiveField(2)
  String urlArchivo;
  @HiveField(3)
  Departamento departamentoArchivo;

  Archivo(
    this.idArchivo,
    this.tituloArchivo,
    this.urlArchivo,
    this.departamentoArchivo
  );

  Object? toJson(){
    return{
      "id_Archivo": idArchivo,
      "titulo_Archivo": tituloArchivo,
      "url_Archivo": urlArchivo,
      "id_Departamento": departamentoArchivo.idDepartamento
    };
  }

  factory Archivo.defaultArchivo(){
    return Archivo(
    0,
    '', 
    '', 
    Departamento.defaultDepartamento()
    );
  }

}