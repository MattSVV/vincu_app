import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vincu_app/model/contenido.dart';
import 'package:vincu_app/model/departamento.dart';
import 'package:vincu_app/model/pantalla.dart';
import 'package:vincu_app/router/routerDepartamento.dart';
import 'package:vincu_app/router/routerPantalla.dart';

class RouterContenido {
  RouterContenido();
  RouterDepartamento rtDep = RouterDepartamento();
  RouterPantalla rtPantalla = RouterPantalla();

  Future<List<Contenido>> listaContenido() async {
    final url = Uri.parse(
      'https://api-vinculacion-0309.onrender.com/api/contenido',
    );
    final response = await http.get(
      url,
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );
    List<Contenido> contenidos = [];
    List<Pantalla> pantallas = await rtPantalla.traerPantalla();
    List<Departamento> departamentos = await rtDep.traerDepa();

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      contenidos =
          data.map((json) {
            // Obtener los ID del JSON
            int idPantalla = json['id_pantalla'];
            int idDepartamento = json['id_departamento'];

            // Buscar los objetos completos
            Pantalla? pantalla = pantallas.firstWhere(
              (p) => p.idPantalla == idPantalla,
              orElse: () => Pantalla.defaultPantalla(),
            );

            Departamento? departamento = departamentos.firstWhere(
              (d) => d.idDepartamento == idDepartamento,
              orElse: () => Departamento.defaultDepartamento(),
            );
            
            // Crear objeto Contenido manualmente
            return Contenido(
              json['id_contenido'],
              json['titulo_contenido'],
              json['subtitulo_contenido'] ?? '',
              json['descripcion_contenido'],
              departamento,
              pantalla,
            );
          }).toList();
    } else {
      print("Error: ${response.statusCode}");
    }
    return contenidos;
  }

  Future<void> guardarContenido(Contenido contenido) async {
    final url = Uri.parse(
      'https://api-vinculacion-0309.onrender.com/api/contenido',
    );
    await http.post(
      url,
      headers: {
        'x-api-key': dotenv.env['API_KEY']!,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contenido.toJson()),
    );

    
  }
}
