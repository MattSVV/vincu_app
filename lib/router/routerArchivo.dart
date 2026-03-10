import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vincu_app/model/archivo.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/router/routerDepartamento.dart';

class RouterArchivo {
  RouterArchivo();
  RouterDepartamento rtDep = RouterDepartamento();

  Future<List<Archivo>> listaArchivo() async {
    final url = Uri.parse('https://api-vinculacion-0309.onrender.com/api/archivo');

    final response = await http.get(
     url,
     headers: {'x-api-key': dotenv.env['API_KEY']!},
    );
    List<Archivo> listaArchivos = [];
    List<Departamento> departamentos = await rtDep.traerDepa();

    if (response.statusCode == 200){
      List<dynamic> data = jsonDecode(response.body);

      listaArchivos = data.map((json) {
        int idDepartamento = json['id_departamento'];

        Departamento? departamento = departamentos.firstWhere(
          (d) => d.idDepartamento == idDepartamento,
          orElse: () => Departamento.defaultDepartamento(),
        );
        return Archivo(json['id_archivo'], json['titulo_archivo'], json['url_archivo'], departamento); 
      }).toList();
    }else {
      print("Error: ${response.statusCode}");
    }
    return listaArchivos;
  }

  Future<void> crearArchivo(Archivo nuevoArchivo) async {
  final urlApi = Uri.parse('https://api-vinculacion-0309.onrender.com/api/archivo');
  await http.post(
    urlApi,
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': dotenv.env['API_KEY']!,
    },
    body: jsonEncode(nuevoArchivo.toJson()),
  );
}

Future<void> actualizarArchivo(Archivo archivoActualizado) async {
  final urlApi = Uri.parse('https://api-vinculacion-0309.onrender.com/api/archivo/${archivoActualizado.idArchivo}');
  await http.put(
    urlApi,
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': dotenv.env['API_KEY']!,
    },
    body: jsonEncode(archivoActualizado.toJson()),
  );
}

Future<bool> eliminarArchivo(int idArchivo) async {
  final urlApi = Uri.parse('https://api-vinculacion-0309.onrender.com/api/archivo/$idArchivo');
  final response = await http.delete(
    urlApi,
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': dotenv.env['API_KEY']!,
    },
  );
  return response.statusCode == 200;
}
}


